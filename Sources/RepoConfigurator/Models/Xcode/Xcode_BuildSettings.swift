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
    class BuildSettings
    {
        // MARK: - Instance level members

        public
        var base: Xcode.RawBuildSettings = [:]

        private
        var overrides: [Xcode.BuildConfiguration: Xcode.RawBuildSettings] = [:]

        public
        subscript(
            configuration: Xcode.BuildConfiguration
            ) -> Xcode.RawBuildSettings
        {
            get
            {
                return overrides[configuration] ?? [:]
            }

            set(newValue)
            {
                overrides[configuration] = newValue
            }
        }

        // MARK: - Initializers

        public
        init() {}
    }
}

// MARK: - Content rendering

extension Xcode.BuildSettings: TextFilePiece
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

        var result: IndentedText = []

        //---

        guard
            !base.isEmpty ||
            !overrides.isEmpty
        else
        {
            return result
        }

        //---

        result += """
            configurations:
            """
            .asIndentedText(with: indentation)

        indentation++

        for configuration in Xcode.BuildConfiguration.allCases
        {
            result += renderSettings(
                for: configuration,
                with: indentation
            )
        }

        indentation--

        //---

        return result
    }

    private
    func renderSettings(
        for configuration: Xcode.BuildConfiguration,
        with indentation: Indentation
        ) -> IndentedText
    {
        var result: IndentedText = []

        //---

        let combinedSettings = base.overriding(with: self[configuration])

        guard
            !combinedSettings.isEmpty
        else
        {
            return result
        }

        //---

        result += """
            \(configuration.name):
            """
            .asIndentedText(with: indentation)

        indentation++

        for item in combinedSettings
        {
            result <<< """
                \(item.key): \"\(item.value)\"
                """
                .asIndentedText(with: indentation)
        }

        indentation--

        //---

        return result
    }
}
