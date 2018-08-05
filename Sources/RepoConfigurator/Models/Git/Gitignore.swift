public
extension Git
{
    struct Gitignore: FixedNameFile
    {
        public
        enum Entry
        {
            case macOS
            case cocoa
            case cocoaPods
            case carthage
            case fastlane
            case custom(String)
        }

        //---

        public
        static
        let fileName = ".gitignore"

        //---

        public
        let entries: [Entry]

        public
        let ignore3dPartySources: Bool

        //---

        public
        func prepareContent() throws -> IndentedText
        {
            return entries
                .map{ type(of: self).processEntry($0, self.ignore3dPartySources) }
                .reduce(into: IndentedText()){ $0 += $1 }
        }

        //---

        public
        init(
            entries: [Entry],
            ignore3dPartySources: Bool
            )
        {
            self.entries = entries
            self.ignore3dPartySources = ignore3dPartySources
        }

        public
        static
        let defaultForApp: Gitignore = .init(
            entries: [
                .macOS,
                .cocoa,
                .cocoaPods,
                .carthage,
                .fastlane
            ],
            ignore3dPartySources: false
        )

        public
        static
        let defaultForFramework: Gitignore = .init(
            entries: [
                .macOS,
                .cocoa,
                .cocoaPods,
                .carthage,
                .fastlane
            ],
            ignore3dPartySources: true
        )

        public
        init(
            basedOn preset: Gitignore? = nil,
            otherEntries: [Entry],
            ignore3dPartySources: Bool? = nil
            )
        {
            self.entries = otherEntries + (preset?.entries ?? [])

            self.ignore3dPartySources = preset?.ignore3dPartySources
                ?? ignore3dPartySources
                ?? false
        }

        //---

        private
        static
        func processEntry(
            _ entry: Entry,
            _ ignore3dPartySources: Bool
            ) -> IndentedText
        {
            switch entry
            {
                case .macOS:
                    return """
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
                        .asIndentedText()

                case .cocoa:
                    return """
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
                        .asIndentedText()

                case .cocoaPods:
                    return """
                        # ==========
                        ### CocoaPods ###

                        # NOTE: never ignore the lock file.
                        # See https://guides.cocoapods.org/using/using-cocoapods.html#what-is-podfilelock

                        \((ignore3dPartySources ? "" : "# ")) Pods/

                        ### CocoaPods ###
                        # ==========
                        #
                        #
                        #
                        """
                        .asIndentedText()

                case .carthage:
                    return """
                        # ==========
                        ### Carthage ###

                        Carthage/Build
                        \((ignore3dPartySources ? "" : "# ")) Carthage/Checkouts

                        ### Carthage ###
                        # ==========
                        #
                        #
                        #
                        """
                        .asIndentedText()

                case .fastlane:
                    return """
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
                        .asIndentedText()

                case .custom(let customEntry):
                    return """
                        # ==========
                        ### Custom repo-specific ###

                        \(customEntry)

                        ### Custom repo-specific ###
                        # ==========
                        #
                        #
                        #
                        """
                        .asIndentedText()
            }
        }
    }
}
