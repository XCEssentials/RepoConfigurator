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
extension Xcode
{
    public
    final
    class Project
    {
        // MARK: Instance level members

        public
        let name: String

        public
        let buildSettings = Xcode.Project.BuildSettings()

        public private(set)
        var targetsByName: [String: TextFilePiece] = [:]

        public
        func targets(
            _ items: XcodeTargetCore...
            )
        {
            items.forEach{

                targetsByName[$0.name] = $0
                targetsByName.override(with: $0.dependentTargets)
            }
        }

        public private(set)
        var schemesByName: [String: Xcode.Scheme] = [:]

        public
        func schemes(
            _ items: Xcode.Scheme...
            )
        {
            items.forEach{

                schemesByName[$0.name] = $0
            }
        }

        public
        var variants: [Xcode.Project.Variant] = []

        /**
         https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#lifecycle-hooks
         */
        public
        var lifecycleHooks: (pre: String?, post: String?) = (nil, nil)

        // MARK: Initializers

        public
        init(
            _ name: String
            )
        {
            self.name = name
        }
    }
}

// MARK: - Content rendering

extension Xcode.Project: TextFilePiece
{
    public
    func asIndentedText(
        with indentation: Indentation
        ) -> IndentedText
    {
        //---

        let result: IndentedTextBuffer = .init(with: indentation)

        //---

        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0

        result <<< """
            # https://github.com/lyptt/struct/wiki/Spec-format:-v2.0

            """

        //---

        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#version-number

        // currently rely on Struct Spec format v.2.2
        let specFormatVersion = "2.2.0"

        result <<< """
            version: \(specFormatVersion)
            """

        //---

        // https://github.com/lyptt/struct/wiki/Spec-format%3A-v2.0#configurations

        result <<< buildSettings

        //---

        // https://github.com/lyptt/struct/wiki/Spec-format%3A-v2.0#targets

        result <<< """
            targets:
            """

        indentation.nest{

            result <<< targetsByName.values.map{

                $0.asIndentedText(with: indentation)
            }
        }

        //---

        // https://github.com/lyptt/struct/wiki/Spec-format%3A-v2.0#schemes

        result <<< """
            schemes:
            """

        //---

        indentation.nest{

            result <<< schemesByName.values.map{

                $0.contentGetter(indentation)
            }
        }

        //---

        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#lifecycle-hooks

        result <<< (lifecycleHooks.pre ?? lifecycleHooks.post != nil).mapIf(true){ """
            scripts:
            """
        }

        indentation.nestIfUnwrap(lifecycleHooks.pre){

            result <<< """
                pre-generate: \($0)
                """
        }

        indentation.nestIfUnwrap(lifecycleHooks.post){

            result <<< """
                post-generate: \($0)
                """
        }

        //---

        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#variants

        result <<< """
            variants:
            """

        //---

        indentation.nest{

            result <<< """
                $base:
                """

            indentation.nest{

                // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#abstract-variants

                result <<< """
                    abstract: true
                    """
            }

            result <<< variants.isEmpty.mapIf(true){ """
                \(self.name):
                """
            }

            result <<< variants
        }

        //---

        return result.content
    }
}
