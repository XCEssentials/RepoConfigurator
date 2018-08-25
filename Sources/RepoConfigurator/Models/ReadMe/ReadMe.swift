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
struct ReadMe: FixedNameTextFile
{
    // MARK: Type level members

    public
    static
    let fileName: String = "README.md"

    // MARK: Instance level members

    public
    let fileContent: IndentedText
}

// MARK: - Presets

public
extension ReadMe
{
    static
    func openSourceProduct(
        header: [TextFileSection<ReadMe>],
        _ content: String?...
        ) -> ReadMe
    {
        let result = IndentedTextBuffer()

        //---

        result <<< header
        result <<< content.compactMap{ $0 }

        //---

        return .init(fileContent: result.content)
    }
}

// MARK: - Content rendering

public
extension TextFileSection
    where
    Context == ReadMe
{
    static
    func gitHubLicenseBadge(
        account: String,
        repo: String,
        link: String? = nil,
        _ parameters: Shields.Parameters = .parameters()
        ) throws -> TextFileSection<Context>
    {
        let imgAltText = "GitHub License"

        let linkToBadge = try Shields
            .Badge
            .special(
                "github/license/\(account)/\(repo).svg",
                parameters
            )
            .output
            .absoluteString

        let link = link
            ?? "https://github.com/\(account)/\(repo)/blob/master/\(Defaults.licenseFileName)"

        let mdImage = Markdown.image(
            imgAltText,
            link: linkToBadge
        )

        let result = Markdown.embed(
            mdImage,
            intoLink: link
            )
            ?? mdImage

        //---

        return .init(contentGetter: result.asIndentedText)
    }

    static
    func gitHubTagBadge(
        account: String,
        repo: String,
        link: String? = nil,
        _ parameters: Shields.Parameters = .parameters()
        ) throws -> TextFileSection<Context>
    {
        let imgAltText = "GitHub Tag"

        let linkToBadge = try Shields
            .Badge
            .special(
                "github/tag/\(account)/\(repo).svg",
                parameters
            )
            .output
            .absoluteString

        let link = link
            ?? "https://github.com/\(account)/\(repo)/tags"

        let mdImage = Markdown.image(
            imgAltText,
            link: linkToBadge
        )

        let result = Markdown.embed(
            mdImage,
            intoLink: link
            )
            ?? mdImage

        //---

        return .init(contentGetter: result.asIndentedText)
    }

    static
    func cocoaPodsVersionBadge(
        podName: String,
        link: String? = nil,
        _ parameters: Shields.Parameters = .parameters()
        ) throws -> TextFileSection<Context>
    {
        let imgAltText = "CocoaPods Version"

        let linkToBadge = try Shields
            .Badge
            .special(
                "cocoapods/v/\(podName).svg",
                parameters
            )
            .output
            .absoluteString

        let link = link
            ?? "https://cocoapods.org/pods/\(podName)"

        let mdImage = Markdown.image(
            imgAltText,
            link: linkToBadge
        )

        let result = Markdown.embed(
            mdImage,
            intoLink: link
            )
            ?? mdImage

        //---

        return .init(contentGetter: result.asIndentedText)
    }

    static
    func cocoaPodsPlatformsBadge(
        podName: String,
        link: String? = nil,
        _ parameters: Shields.Parameters = .parameters()
        ) throws -> TextFileSection<Context>
    {
        let imgAltText = "CocoaPods Platforms"

        let linkToBadge = try Shields
            .Badge
            .special(
                "cocoapods/p/\(podName).svg",
                parameters
            )
            .output
            .absoluteString

        let link = link
            ?? "https://cocoapods.org/pods/\(podName)"

        let mdImage = Markdown.image(
            imgAltText,
            link: linkToBadge
        )

        let result = Markdown.embed(
            mdImage,
            intoLink: link
            )
            ?? mdImage

        //---

        return .init(contentGetter: result.asIndentedText)
    }

    static
    func carthageCompatibleBadge(
        status: String = "compatible",
        color: String = "brightgreen",
        _ parameters: Shields.Parameters = .parameters()
        ) throws -> TextFileSection<Context>
    {
        let imgAltText = "Carthage Compatible"

        let linkToBadge = try Shields
            .Badge
            .static(
                "Carthage",
                status: status,
                color: color,
                parameters
            )
            .output
            .absoluteString

        let link = "https://github.com/Carthage/Carthage"

        let mdImage = Markdown.image(
            imgAltText,
            link: linkToBadge
        )

        let result = Markdown.embed(
            mdImage,
            intoLink: link
            )
            ?? mdImage

        //---

        return .init(contentGetter: result.asIndentedText)
    }

    static
    func writtenInSwiftBadge(
        version swiftVersionNumber: String = Defaults.swiftVersion,
        _ parameters: Shields.Parameters = .parameters()
        ) throws -> TextFileSection<Context>
    {
        let imgAltText = "Written in Swift"

        let linkToBadge = try Shields
            .Badge
            .static(
                "Swift",
                status: swiftVersionNumber,
                color: "orange",
                parameters
            )
            .output
            .absoluteString

        let link = "https://developer.apple.com/swift/"

        let mdImage = Markdown.image(
            imgAltText,
            link: linkToBadge
        )

        let result = Markdown.embed(
            mdImage,
            intoLink: link
            )
            ?? mdImage

        //---

        return .init(contentGetter: result.asIndentedText)
    }

    static
    func staticShieldsBadge(
        _ subject: String,
        status: String,
        color: String,
        _ parameters: Shields.Parameters = .parameters(),
        title: String,
        link: String
        ) throws -> TextFileSection<Context>
    {
        let linkToBadge = try Shields
            .Badge
            .static(
                subject,
                status: status,
                color: color,
                parameters
            )
            .output
            .absoluteString

        let mdImage = Markdown.image(
            title,
            link: linkToBadge
        )

        let result = Markdown.embed(
            mdImage,
            intoLink: link
            )
            ?? mdImage

        //---

        return .init(contentGetter: result.asIndentedText)
    }

    static
    func newLine(
        ) -> TextFileSection<Context>
    {
        return .init(contentGetter: "\n".asIndentedText)
    }

    static
    func emptyLine(
        ) -> TextFileSection<Context>
    {
        return .init(contentGetter: "\n\n".asIndentedText)
    }

    static
    func custom(
        _ content: String
        ) -> TextFileSection<Context>
    {
        return .init(contentGetter: content.asIndentedText)
    }
}
