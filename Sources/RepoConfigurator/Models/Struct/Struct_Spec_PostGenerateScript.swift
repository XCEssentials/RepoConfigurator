/*

 MIT License

 Copyright (c) 2018 Maxim Khatskevich

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.

 */

import Foundation

//---

public
extension Struct.Spec
{
    public
    struct PostGenerateScript: ArbitraryNamedTextFile
    {
        // MARK: Type level members

        public
        static
        let defaultSpecVar = "spec"

        public
        static
        let defaultXcodeprojVar = "xcodeproj"

        public
        static
        let defaultFileName = "struct-post-generate.rb"

        public
        func prepareWithDefaultName(
            targetFolder: String,
            removeSpacesAtEOL: Bool = true,
            removeRepeatingEmptyLines: Bool = true
            ) throws -> RawTextFile<PostGenerateScript>
        {
            return try prepare(
                name: type(of: self).defaultFileName,
                targetFolder: targetFolder,
                removeSpacesAtEOL: removeSpacesAtEOL,
                removeRepeatingEmptyLines: removeRepeatingEmptyLines
            )
        }

        // MARK: Instance level members

        public
        let fileContent: IndentedText

        // MARK: Initializers

        public
        init(
            specVar spec: String = defaultSpecVar,
            xcodeprojVar xcodeproj: String = defaultXcodeprojVar,
            _ sections: TextFileSection<Struct.Spec.PostGenerateScript>...
            )
        {
            let result = IndentedTextBuffer()

            //---

            result <<< """
                # post-generate Struct script
                # https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#lifecycle-hooks

                run do |\(spec), \(xcodeproj)|

                """

            result.indentation.nest{

                result <<< sections
            }

            result <<< """

                end
                """

            //---

            self.fileContent = result.content
        }
    }
}

// MARK: - Content rendering

public
extension TextFileSection
    where
    Context == Struct.Spec.PostGenerateScript
{
    /**
     Allows to set 'PRODUCT_NAME' build setting of certain targets to
     '$(inherited)' so that those target products be named according to
     project level value of 'PRODUCT_NAME' build setting. By default 'PRODUCT_NAME'
     is set to be equal to the target name. This technique is meant to be used for
     cross-platform frameworks when target names reflect specific platforms, while
     module name should be the same across all platforms.
     */
    static
    func inheritedModuleName(
        xcodeprojVar xcodeproj: String = Struct.Spec.PostGenerateScript.defaultXcodeprojVar,
        productTypes: [Xcodeproj.ProductType]
        ) -> TextFileSection<Context>
    {
        return .init{

            indentation in

            //---

            let result = IndentedTextBuffer(with: indentation)

            //---

            //swiftlint:disable line_length

            result <<< """
                # https://www.rubydoc.info/github/CocoaPods/Xcodeproj/Xcodeproj/Project
                # https://github.com/CocoaPods/Xcodeproj/blob/master/spec/project/object/native_target_spec.rb
                # https://github.com/CocoaPods/Xcodeproj/blob/c6c1c86459720e5dfbe406eb613a2d2de1607ee2/lib/xcodeproj/constants.rb#L125

                \(xcodeproj)
                """

            //swiftlint:enable line_length

            indentation.nest{

                result <<< """
                    .targets
                    .select{ |t| \(productTypes.map{ $0.rawValue }).include?(t.product_type) }
                    .each{ |t|

                    """

                indentation.nest{

                    result <<< """
                        t.build_configurations.each do |config|

                        """

                    indentation.nest{

                        result <<< """
                            config.build_settings['PRODUCT_NAME'] = '$(inherited)'
                            """
                    }

                    result <<< """
                        end
                        """
                }

                result <<< """
                    }
                    """
            }

            result <<< """

                \(xcodeproj).save()
                """

            //---

            return result.content
        }
    }

    static
    func custom(
        _ content: String
        ) -> TextFileSection<Context>
    {
        return .init{

            let result = IndentedTextBuffer(with: $0)

            //---

            result <<< """

                \(content)
                """

            //---

            return result.content
        }
    }
}
