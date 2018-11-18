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

public
extension Xcode.Project
{
    public
    final
    class BuildSettings: Xcode.BuildSettings {}
}

// MARK: - Content rendering

extension Xcode.Project.BuildSettings: TextFilePiece
{
    public
    func asIndentedText(
        with indentation: Indentation
        ) -> IndentedText
    {
        // NOTE: build settings inside a target follow similar format to
        // ones on project level, EXCEPT they are one level up, nested
        // directly under build configuration name, WITHOUT 'overrides'
        // intermediate key, see more at the URL below.
        // https://github.com/lyptt/struct/issues/77#issuecomment-287573381
        //
        // See also - build settings on PROJECT level docs:
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#overrides

        //---

        // render configurations explicitly EVEN
        // if there is no overrides, due to a bug in Struct 3.1.2

        //---

        let result: IndentedTextBuffer = .init(with: indentation)

        //---

        result <<< """
            configurations:
            """

        indentation.nest{

            result <<< Xcode.BuildConfiguration.allCases.map{

                renderSettings(for: $0, with: indentation)
            }
        }

        //---

        return result.content
    }

    private
    func renderSettings(
        for configuration: Xcode.BuildConfiguration,
        with indentation: Indentation
        ) -> IndentedText
    {
        let result: IndentedTextBuffer = .init(with: indentation)

        //---

        result <<< """
            \(configuration):
            """
        
        if
            let externalConfig = externalConfig[configuration]
        {
            indentation.nest{

                // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#xcconfig-references

                // NOTE: when using xcconfig files,
                // any overrides will be ignored.

                result <<< """
                    source: \(externalConfig)
                    """
            }
        }
        else
        if
            let combinedSettings = Optional(base.overriding(with: self[configuration])),
            !combinedSettings.isEmpty
        {
            indentation.nest{

                // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#overrides

                result <<< """
                    overrides:
                    """

                indentation.nest{

                    result <<< combinedSettings.sortedByKey().map{ """
                        \($0.key): '\($0.value)'
                        """
                    }
                }
            }
        }

        //---

        return result.content
    }
}
