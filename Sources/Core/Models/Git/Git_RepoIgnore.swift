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

import PathKit

//---

extension Git
{
    public
    final
    class RepoIgnore: FixedNameTextFile
    {
        // MARK: Type level members

        public
        static
        let relativeLocation: Path = [".gitignore"]

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
}

// MARK: - Presets

public
extension Git.RepoIgnore
{
    public
    static
    func app(
        ignoreDependenciesSources: Bool = false,
        archivesExportLocation: Path = Defaults.archivesExportLocation,
        otherEntries: [String] = []
        ) -> Git.RepoIgnore
    {
        let result = Git
            .RepoIgnore()
            .addMacOSSection()
            .addCocoaSection()
            .addSwiftPackageManagerSection(ignoreSources: ignoreDependenciesSources)
            .addCocoaPodsSection(ignoreSources: ignoreDependenciesSources)
            .addCarthageSection(ignoreSources: ignoreDependenciesSources)
            .addFastlaneSection()
            .addArchivesExportPathSection(archivesExportLocation)

        _ = result.add(
            otherEntries.joined(
                separator: "\n"
            )
        )

        //---

        return result
    }

    public
    static
    func framework(
        ignoreDependenciesSources: Bool = true,
        otherEntries: [String] = []
        ) -> Git.RepoIgnore
    {
        let result = Git
            .RepoIgnore()
            .addMacOSSection()
            .addCocoaSection()
            .addSwiftPackageManagerSection(ignoreSources: ignoreDependenciesSources)
            .addCocoaPodsSection(ignoreSources: ignoreDependenciesSources)
            .addCarthageSection(ignoreSources: ignoreDependenciesSources)
            .addFastlaneSection()

        _ = result.add(
            otherEntries.joined(
                separator: "\n"
            )
        )

        //---

        return result
    }
}

// MARK: - Content rendering

public
extension Git.RepoIgnore
{
    func addMacOSSection(
        ) -> Git.RepoIgnore
    {
        buffer <<< """

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

        //---

        return self
    }

    func addCocoaSection(
        ) -> Git.RepoIgnore
    {
        buffer <<<  """

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

            ### Cocoa ###
            # ==========
            #
            #
            #
            """

        //---

        return self
    }

    func addSwiftPackageManagerSection(
        ignoreSources: Bool
        ) -> Git.RepoIgnore
    {
        buffer <<< """

            # ==========
            ### Swift Package Manager ###
            #
            \((ignoreSources ? "" : "# "))Packages/
            \((ignoreSources ? "" : "# "))Package.pins
            .build/

            ### Swift Package Manager ###
            # ==========
            #
            #
            #
            """

        //---

        return self
    }

    func addCocoaPodsSection(
        ignoreSources: Bool
        ) -> Git.RepoIgnore
    {
        buffer <<< """

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

        //---

        return self
    }

    func addCarthageSection(
        ignoreSources: Bool
        ) -> Git.RepoIgnore
    {
        buffer <<< """

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

        //---

        return self
    }

    func addFastlaneSection(
        ) -> Git.RepoIgnore
    {
        buffer <<< """

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

        //---

        return self
    }

    func addArchivesExportPathSection(
        _ archivesExportLocation: Path
        ) -> Git.RepoIgnore
    {
        buffer <<< """

            # ==========
            ### Archives Export Path (for apps only) ###

            \(archivesExportLocation.string)

            ### Archives Export Path (for apps only) ###
            # ==========
            #
            #
            #
            """

        //---

        return self
    }

    func add(
        _ customEntry: String
        ) -> Git.RepoIgnore
    {
        buffer <<< """

            # ==========
            ### Custom repo-specific ###

            \(customEntry)

            ### Custom repo-specific ###
            # ==========
            #
            #
            #
            """

        //---

        return self
    }
}
