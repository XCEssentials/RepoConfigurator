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
final
class ReadMe: FixedNameTextFile
{
    // MARK: Type level members

    public
    static
    let fileName: String = "README.md"

    // MARK: Instance level members

    private
    var buffer: IndentedTextBuffer = .init()

    public
    var fileContent: IndentedText
    {
        return buffer.content
    }

    // MARK: Initializers

    public
    init() {}
}

// MARK: - Content rendering

public
extension ReadMe
{
    func addGitHubLicenseBadge(
        account: String,
        repo: String,
        link: String? = nil,
        _ parameters: Shields.Parameters = .parameters()
        ) throws -> ReadMe
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
            ?? "\(Defaults.licenseFileName)"

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

        buffer <<< result

        //---

        return self
    }

    func addGitHubTagBadge(
        account: String,
        repo: String,
        link: String? = nil,
        _ parameters: Shields.Parameters = .parameters()
        ) throws -> ReadMe
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

        buffer <<< result

        //---

        return self
    }

    func addCocoaPodsVersionBadge(
        podName: String,
        link: String? = nil,
        _ parameters: Shields.Parameters = .parameters()
        ) throws -> ReadMe
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
            ?? "\(podName).podspec"

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

        buffer <<< result

        //---

        return self
    }

    func addCocoaPodsPlatformsBadge(
        podName: String,
        link: String? = nil,
        _ parameters: Shields.Parameters = .parameters()
        ) throws -> ReadMe
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
            ?? "\(podName).podspec"

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

        buffer <<< result

        //---

        return self
    }

    func addCarthageCompatibleBadge(
        status: String = "compatible",
        color: String = "brightgreen",
        _ parameters: Shields.Parameters = .parameters()
        ) throws -> ReadMe
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

        buffer <<< result

        //---

        return self
    }

    func addSwiftPMCompatibleBadge(
        status: String = "compatible",
        color: String = "brightgreen",
        _ parameters: Shields.Parameters = .parameters()
        ) throws -> ReadMe
    {
        let imgAltText = "Swift Package Manager Compatible"

        let linkToBadge = try Shields
            .Badge
            .static(
                "SPM",
                status: status,
                color: color,
                parameters
            )
            .output
            .absoluteString

        let link = "Package.swift"

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

        buffer <<< result

        //---

        return self
    }

    func addWrittenInSwiftBadge(
        version swiftVersionNumber: String = Defaults.swiftVersion,
        _ parameters: Shields.Parameters = .parameters()
        ) throws -> ReadMe
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

        let link = "https://swift.org"

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

        buffer <<< result

        //---

        return self
    }

    func addStaticShieldsBadge(
        _ subject: String,
        status: String,
        color: String,
        _ parameters: Shields.Parameters = .parameters(),
        title: String,
        link: String
        ) throws -> ReadMe
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

        buffer <<< result

        //---

        return self
    }

    func addNewLine(
        ) -> ReadMe
    {
        buffer <<< "\n"

        //---

        return self
    }

    func addEmptyLine(
        ) -> ReadMe
    {
        buffer <<< "\n\n"

        //---

        return self
    }

    func add(
        _ content: String
        ) -> ReadMe
    {
        buffer <<< content

        //---

        return self
    }
}
