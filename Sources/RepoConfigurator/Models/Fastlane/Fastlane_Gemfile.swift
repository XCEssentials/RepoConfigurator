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
extension Fastlane
{
    public
    struct Gemfile: FixedNameTextFile, ConfigurableTextFile
    {
        // MARK: - Type level members

        public
        enum Section: TextFilePiece
        {
            case defaultHeader

            case fastlane

            case custom(
                String
            )
        }

        // MARK: - Instance level members

        public
        var fileContent: IndentedText = []

        // MARK: - Initializers

        public
        init() {}
    }
}

// MARK: - Presets

public
extension Fastlane.Gemfile
{
    /**
     https://docs.fastlane.tools/getting-started/ios/setup/#use-a-gemfile
     */
    static
    func fastlaneSupportOnly() -> Fastlane.Gemfile
    {
        return .init(
            .defaultHeader,
            .fastlane
        )
    }
}

// MARK: - Content rendering

public
extension Fastlane.Gemfile.Section
{
    func asIndentedText(
        with indentation: inout Indentation
        ) -> IndentedText
    {
        var result: IndentedText = []

        //---

        switch self
        {
        case .defaultHeader:
            result <<< """
                source "https://rubygems.org"

                """
                .asIndentedText(with: &indentation)

        case .fastlane:
            result <<< """

                gem "fastlane"
                """
                .asIndentedText(with: &indentation)

        case .custom(
            let customEntry
            ):
            result <<< """

                \(customEntry)
                """
                .asIndentedText(with: &indentation)
        }

        //---

        return result
    }
}
