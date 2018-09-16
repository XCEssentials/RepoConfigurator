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
        struct Sections
        {
            private
            let xcodeprojVar: String
            
            private
            let buffer: IndentedTextBuffer

            //internal
            init(
                xcodeprojVar: String,
                buffer: IndentedTextBuffer
                )
            {
                self.xcodeprojVar = xcodeprojVar
                self.buffer = buffer
            }
        }

        // MARK: Instance level members

        public
        func prepareWithDefaultName(
            targetFolder: String,
            removeSpacesAtEOL: Bool = true,
            removeRepeatingEmptyLines: Bool = true
            ) -> PendingTextFile<PostGenerateScript>
        {
            return prepare(
                name: type(of: self).defaultFileName,
                targetFolder: targetFolder,
                removeSpacesAtEOL: removeSpacesAtEOL,
                removeRepeatingEmptyLines: removeRepeatingEmptyLines
            )
        }

        private
        var buffer = IndentedTextBuffer()

        public
        var fileContent: IndentedText
        {
            return buffer.content
        }

        // MARK: Initializers

        public
        init(
            specVar spec: String = defaultSpecVar,
            xcodeprojVar xcodeproj: String = defaultXcodeprojVar,
            sections: (Sections) -> Void
            )
        {
            buffer <<< """
                # post-generate Struct script
                # https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#lifecycle-hooks

                run do |\(spec), \(xcodeproj)|

                """

            buffer.indentation.nest{

                sections(
                    Sections(
                        xcodeprojVar: xcodeproj,
                        buffer: buffer
                    )
                )
            }

            buffer <<< """

                end
                """
        }
    }
}

// MARK: - Content rendering

public
extension Struct.Spec.PostGenerateScript.Sections
{
    /**
     Allows to set 'PRODUCT_NAME' build setting of certain targets to
     '$(inherited)' so that those target products be named according to
     project level value of 'PRODUCT_NAME' build setting. By default 'PRODUCT_NAME'
     is set to be equal to the target name. This technique is meant to be used for
     cross-platform frameworks when target names reflect specific platforms, while
     module name should be the same across all platforms.
     */
    func inheritedModuleName(
        productTypes: [Xcodeproj.ProductType]
        )
    {
        //swiftlint:disable line_length

        buffer <<< """
            # === Targets to inherit module name from project ===
            
            # https://www.rubydoc.info/github/CocoaPods/Xcodeproj/Xcodeproj/Project
            # https://github.com/CocoaPods/Xcodeproj/blob/master/spec/project/object/native_target_spec.rb
            # https://github.com/CocoaPods/Xcodeproj/blob/c6c1c86459720e5dfbe406eb613a2d2de1607ee2/lib/xcodeproj/constants.rb#L125

            \(xcodeprojVar)
            """

        //swiftlint:enable line_length

        buffer.indentation.nest{

            buffer <<< """
                .targets
                .select{ |t| \(productTypes.map{ $0.rawValue }).include?(t.product_type) }
                .each{ |t|

                """

            buffer.indentation.nest{

                buffer <<< """
                    t.build_configurations.each do |config|

                    """

                buffer.indentation.nest{

                    buffer <<< """
                        config.build_settings['PRODUCT_NAME'] = '$(inherited)'
                        """
                }

                buffer <<< """
                    end
                    """
            }

            buffer <<< """
                }
                """
        }

        buffer <<< """

            \(xcodeprojVar).save()
            """
    }

    func custom(
        _ content: String
        )
    {
        buffer <<< """

            \(content)
            """
    }
}
