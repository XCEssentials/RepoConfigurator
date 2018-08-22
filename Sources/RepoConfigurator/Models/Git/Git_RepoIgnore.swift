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
    struct RepoIgnore: FixedNameTextFile
    {
        // MARK: - Type level members

        public
        static
        let fileName = ".gitignore"

        // MARK: - Instance level members

        public
        let fileContent: IndentedText
    }
}

// MARK: - Presets

public
extension Git.RepoIgnore
{
    public
    static
    func app(
        ignoreDependenciesSources: Bool = false,
        archivesExportPath: String = Defaults.archivesExportPath,
        otherEntries: [String] = []
        ) -> Git.RepoIgnore
    {
        let sections: [TextFileSection<Git.RepoIgnore>] = [

            .macOS(),
            .cocoa(),
            .cocoaPods(ignoreSources: ignoreDependenciesSources),
            .carthage(ignoreSources: ignoreDependenciesSources),
            .fastlane(),
            .archivesExportPath(archivesExportPath)
        ]

        //---

        let result = IndentedTextBuffer()

        //---

        result <<< sections

        result <<< otherEntries

        //---

        return .init(fileContent: result.content)
    }

    public
    static
    func framework(
        ignoreDependenciesSources: Bool = true,
        otherEntries: [String] = []
        ) -> Git.RepoIgnore
    {
        let sections: [TextFileSection<Git.RepoIgnore>] = [

            .macOS(),
            .cocoa(),
            .cocoaPods(ignoreSources: ignoreDependenciesSources),
            .carthage(ignoreSources: ignoreDependenciesSources),
            .fastlane()
        ]

        //---

        let result = IndentedTextBuffer()

        //---

        result <<< sections

        result <<< otherEntries

        //---

        return .init(fileContent: result.content)
    }
}

// MARK: - Content rendering

fileprivate
extension TextFileSection
    where
    Context == Git.RepoIgnore
{
    static
    func macOS(
        ) -> TextFileSection<Context>
    {
        return .init{ """

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
            .asIndentedText(with: $0)
        }
    }

    static
    func cocoa(
        ) -> TextFileSection<Context>
    {
        return .init{ """

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
            .asIndentedText(with: $0)
        }
    }

    static
    func cocoaPods(
        ignoreSources: Bool
        ) -> TextFileSection<Context>
    {
        return .init{ """

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
            .asIndentedText(with: $0)
        }
    }

    static
    func carthage(
        ignoreSources: Bool
        ) -> TextFileSection<Context>
    {
        return .init{ """

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
            .asIndentedText(with: $0)
        }
    }

    static
    func fastlane(
        ) -> TextFileSection<Context>
    {
        return .init{ """

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
            .asIndentedText(with: $0)
        }
    }

    static
    func archivesExportPath(
        _ archivesExportPath: String
        ) -> TextFileSection<Context>
    {
        return .init{ """

            # ==========
            ### Archives Export Path (for apps only) ###

            \(archivesExportPath)

            ### Archives Export Path (for apps only) ###
            # ==========
            #
            #
            #
            """
            .asIndentedText(with: $0)
        }
    }

    static
    func custom(
        _ customEntry: String
        ) -> TextFileSection<Context>
    {
        return .init{ """

            # ==========
            ### Custom repo-specific ###

            \(customEntry)

            ### Custom repo-specific ###
            # ==========
            #
            #
            #
            """
            .asIndentedText(with: $0)
        }
    }
}
