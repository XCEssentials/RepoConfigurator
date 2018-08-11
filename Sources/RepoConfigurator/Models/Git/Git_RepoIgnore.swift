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

extension Git
{
    public
    struct RepoIgnore: FixedNameTextFile, ConfigurableTextFile
    {
        // MARK: - Type level members

        public
        static
        let fileName = ".gitignore"

        public
        enum Section: TextFilePiece
        {
            case macOS
            case cocoa
            case cocoaPods(ignoreSources: Bool)
            case carthage(ignoreSources: Bool)
            case fastlane
            case archivesExportPath(String) // for apps only
            case custom(String)
        }

        // MARK: - Instance level members

        public
        var fileContent: [IndentedTextGetter] = []
    }
}

// MARK: - Presets

public
extension Git.RepoIgnore
{
    public
    static
    func app(
        archivesExportPath: String = Defaults.archivesExportPath
        ) -> Git.RepoIgnore
    {
        return self
            .init()
            .extend(
                .macOS,
                .cocoa,
                .cocoaPods(ignoreSources: false),
                .carthage(ignoreSources: false),
                .fastlane,
                .archivesExportPath(archivesExportPath)
            )
    }

    public
    static
    let framework = Git
        .RepoIgnore
        .init()
        .extend(
            .macOS,
            .cocoa,
            .cocoaPods(ignoreSources: true),
            .carthage(ignoreSources: true),
            .fastlane
        )
}

// MARK: - Content rendering

public
extension Git.RepoIgnore.Section
{
    func asIndentedText(
        with indentation: inout Indentation
        ) -> IndentedText
    {
        let result: String

        //---

        switch self
        {
        case .macOS:
            result = """

                # ==========
                ### macOS ###

                *.DS_Store
                .AppleDouble
                .LSOverride

                # Icon must end with two \r
                Icon

                # Thumbnails
                ._*

                # Files that might appear in the root of a volume
                .DocumentRevisions-V100
                .fseventsd
                .Spotlight-V100
                .TemporaryItems
                .Trashes
                .VolumeIcon.icns
                .com.apple.timemachine.donotpresent

                # Directories potentially created on remote AFP share
                .AppleDB
                .AppleDesktop
                Network Trash Folder
                Temporary Items
                .apdisk

                ### macOS ###
                # ==========
                #
                #
                #
                """

        case .cocoa:
            result = """

                # ==========
                ### Cocoa ###

                # Xcode

                ## Build generated
                build/
                DerivedData/

                ## Various settings
                *.pbxuser
                !default.pbxuser
                *.mode1v3
                !default.mode1v3
                *.mode2v3
                !default.mode2v3
                *.perspectivev3
                !default.perspectivev3
                xcuserdata/

                ## Other
                *.moved-aside
                *.xccheckout
                *.xcscmblueprint

                ## Obj-C/Swift specific
                *.hmap
                *.ipa
                *.dSYM.zip
                *.dSYM

                ## Playgrounds
                timeline.xctimeline
                playground.xcworkspace

                # Swift Package Manager
                #
                # Add this line if you want to avoid checking in source code from Swift Package Manager dependencies.
                # Packages/
                # Package.pins
                .build/

                ### Cocoa ###
                # ==========
                #
                #
                #
                """

        case .cocoaPods(
            let ignoreSources
            ):
            result = """

                # ==========
                ### CocoaPods ###

                # NOTE: never ignore the lock file.
                # See https://guides.cocoapods.org/using/using-cocoapods.html#what-is-podfilelock

                \((ignoreSources ? "" : "# "))Pods/

                ### CocoaPods ###
                # ==========
                #
                #
                #
                """

        case .carthage(
            let ignoreSources
            ):
            result = """

                # ==========
                ### Carthage ###

                Carthage/Build
                \((ignoreSources ? "" : "# "))Carthage/Checkouts

                ### Carthage ###
                # ==========
                #
                #
                #
                """

        case .fastlane:
            result = """

                # ==========
                ### Fastlane ###

                # For more information about the recommended setup visit:
                # https://docs.fastlane.tools/best-practices/source-control/#source-control

                fastlane/README.md
                fastlane/report.xml
                fastlane/Preview.html
                fastlane/screenshots
                fastlane/test_output

                ### Fastlane ###
                # ==========
                #
                #
                #
                """

        case .archivesExportPath(
            let archivesExportPath
            ):
            result = """

                # ==========
                ### Archives Export Path (for apps only) ###

                \(archivesExportPath)

                ### Archives Export Path (for apps only) ###
                # ==========
                #
                #
                #
                """

        case .custom(
            let customEntry
            ):
            result = """

                # ==========
                ### Custom repo-specific ###

                \(customEntry)

                ### Custom repo-specific ###
                # ==========
                #
                #
                #
                """
        }

        //---

        return result.asIndentedText(with: &indentation)
    }
}
