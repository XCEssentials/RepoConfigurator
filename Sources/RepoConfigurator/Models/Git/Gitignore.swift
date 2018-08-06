public
extension Git
{
    struct RepoGitignore: FixedNameFile
    {
        // MARK: - Type level members

        public
        enum Section
        {
            case macOS
            case cocoa
            case cocoaPods(ignoreSources: Bool)
            case carthage(ignoreSources: Bool)
            case fastlane
            case custom(String)
        }

        public
        static
        let fileName = ".gitignore"

        // MARK: - Instance level members

        public
        let fileContent: IndentedText

        // MARK: - Initializers

        public
        init(
            _ sections: [Section]
            )
        {
            fileContent = sections
                .map{

                    sectionId -> IndentedText in

                    //---

                    switch sectionId
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

                        case .cocoaPods(let ignoreSources):
                            return """
                                # ==========
                                ### CocoaPods ###

                                # NOTE: never ignore the lock file.
                                # See https://guides.cocoapods.org/using/using-cocoapods.html#what-is-podfilelock

                                \((ignoreSources ? "" : "# ")) Pods/

                                ### CocoaPods ###
                                # ==========
                                #
                                #
                                #
                                """
                                .asIndentedText()

                        case .carthage(let ignoreSources):
                            return """
                                # ==========
                                ### Carthage ###

                                Carthage/Build
                                \((ignoreSources ? "" : "# ")) Carthage/Checkouts

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
                .reduce(into: IndentedText()){ $0 += $1 }
        }

        public
        init(
            _ sections: Section...
            )
        {
            self.init(sections)
        }

        public
        init(
            basedOn preset: RepoGitignore,
            _ otherSections: Section...
            )
        {
            fileContent = preset.fileContent + RepoGitignore(otherSections).fileContent
        }

        // MARK: - Presets

        public
        static
        let defaultForApp: RepoGitignore = .init(
            .macOS,
            .cocoa,
            .cocoaPods(ignoreSources: false),
            .carthage(ignoreSources: false),
            .fastlane
        )

        public
        static
        let defaultForFramework: RepoGitignore = .init(
            .macOS,
            .cocoa,
            .cocoaPods(ignoreSources: true),
            .carthage(ignoreSources: true),
            .fastlane
        )
    }
}
