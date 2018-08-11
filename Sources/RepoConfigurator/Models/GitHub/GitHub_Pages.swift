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
extension GitHub
{
    public
    struct Pages: FixedNameTextFile, ConfigurableTextFile
    {
        // MARK: - Type level members

        public
        static
        let fileName: String = "_config.yml"

        public
        enum Section: TextFilePiece
        {
            case theme(String)
            case custom(String)
        }

        // MARK: - Instance level members

        public
        var fileContent: [IndentedTextGetter] = []
    }
}

// MARK: - Presets

public
extension GitHub.Pages
{
    static
    func openSourceFramework(
        themeName: String = "jekyll-theme-cayman",
        otherEntries: String...
        ) -> GitHub.Pages
    {
        return self
            .init()
            .extend(
                .theme(themeName)
            )
            .extend(
                with: otherEntries.map{ .custom($0) }
            )
    }
}

// MARK: - Content rendering

public
extension GitHub.Pages.Section
{
    func asIndentedText(
        with indentation: inout Indentation
        ) -> IndentedText
    {
        let result: String

        //---

        switch self
        {
        case .theme(
            let themeName
            ):
            result = """

                theme: \(themeName)
                """

        case .custom(
            let customEntry
            ):
            result = """

                \(customEntry)
                """
        }

        //---

        return result.asIndentedText(with: &indentation)
    }
}
