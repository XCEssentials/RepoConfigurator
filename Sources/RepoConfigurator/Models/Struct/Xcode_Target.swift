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
    class Target
    {
        // MARK: - Instance level members

        public
        let name: String

        public private(set)
        var includes: [String] = []

        public
        func include(
            _ paths: String...
            )
        {
            includes.append(contentsOf: paths)
        }

        public private(set)
        var excludes: [String] = []

        public
        func exclude(
            _ patterns: String...
            )
        {
            excludes.append(contentsOf: patterns)
        }

        public
        var sourceFilesOptions: [String: String] = [:]

        public private(set)
        var i18nResources: [String] = []

        public
        func i18nResource(
            _ paths: String...
            )
        {
            i18nResources.append(contentsOf: paths)
        }

        public
        let buildSettings = Xcode.Target.BuildSettings()

        public
        let dependencies = Xcode.Dependencies()

        public
        var scripts = Xcode.Scripts()

        public
        var includesCocoapods = false

        // MARK: - Initializers

        //internal
        init(
            _ name: String
            )
        {
            self.name = name
        }
    }
}

// MARK: - Content rendering

public
extension Xcode.Target
{
    //internal - getting ready to conform to 'XcodeTargetCore'
    func renderCoreSettings(
        with indentation: Indentation
        ) -> IndentedText
    {
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#targets

        //---

        let result: IndentedTextBuffer = .init(with: indentation)

        //---

        // NOTE: we skip 'name' and only render settings,
        // 'name' and any extra settings should be rendered in a subclass!

        //---

        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#references

        result <<< dependencies
            .asIndentedText(with: indentation)

        //---

        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#sources

        result <<< includes.isEmpty.mapIf(false){ """
            sources:
            """
        }

        result <<< includes.map{ """
            - \($0)
            """
        }

        //---

        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#excludes

        result <<< excludes.isEmpty.mapIf(false){ """
            excludes:
            """
        }

        indentation.nest{

            result <<< excludes.isEmpty.mapIf(false){ """
                files:
                """
            }

            result <<< excludes.map{ """
                - "\($0)"
                """
            }
        }

        //---

        // https://github.com/workshop/struct/wiki/Spec-format:-v2.0#options

        result <<< """
            source_options:
            """

        indentation.nest{

            result <<< sourceFilesOptions.map{ """
                "\($0.key)": \($0.value)
                """
            }
        }

        //---

        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#i18n-resources

        result <<< i18nResources.isEmpty.mapIf(false){ """
            i18n-resources:
            """
        }

        result <<< i18nResources.map{ """
            - \($0)
            """
        }

        //---

        result <<< buildSettings
            .asIndentedText(with: indentation)

        //---

        result <<< scripts
            .asIndentedText(with: indentation)

        //---

        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#cocoapods

        result <<< includesCocoapods.mapIf(true){ """
            includes_cocoapods: true
            """
        }

        //---

        return result.content
    }
}
