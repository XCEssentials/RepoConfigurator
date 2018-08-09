public
extension Xcode.Project.Target
{
    public
    struct InfoPlist: ArbitraryNamedTextFile, ConfigurableTextFile
    {
        // MARK: - Type level members

        public
        enum PackageType: String
        {
            case app = "APPL"
            case framework = "FMWK"
            case tests = "BNDL"
        }

        public
        enum Section: TextFilePiece
        {
            case header

            case basic(
                packageType: PackageType,
                initialVersionString: VersionString,
                initialBuildNumber: BuildNumber
            )

            case iOSApp

            case macOSApp(
                copyrightYear: UInt,
                copyrightEntity: String
            )

            case macOSFramework(
                copyrightYear: UInt,
                copyrightEntity: String
            )

            case custom(String)

            case footer
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
extension Xcode.Project.Target.InfoPlist
{
    static
    func iOSFramework(
        initialVersionString: VersionString = Defaults.initialVersionString,
        initialBuildNumber: BuildNumber = Defaults.initialBuildNumber,
        _ customSections: String...
        ) -> Xcode.Project.Target.InfoPlist
    {
        var sections: [Section] = [
            .header,
            .basic(
                packageType: .framework,
                initialVersionString: initialVersionString,
                initialBuildNumber: initialBuildNumber
            )
        ]

        sections += customSections.map{
            .custom($0)
        }

        sections += [
            .footer
        ]

        //---

        return .init(sections: sections)
    }

    static
    func iOSApp(
        initialVersionString: VersionString = Defaults.initialVersionString,
        initialBuildNumber: BuildNumber = Defaults.initialBuildNumber,
        _ customSections: String...
        ) -> Xcode.Project.Target.InfoPlist
    {
        var sections: [Section] = [
            .header,
            .basic(
                packageType: .app,
                initialVersionString: initialVersionString,
                initialBuildNumber: initialBuildNumber
            ),
            .iOSApp
        ]

        sections += customSections.map{
            .custom($0)
        }

        sections += [
            .footer
        ]

        //---

        return .init(sections: sections)
    }

    static
    func macOSFramework(
        initialVersionString: VersionString = Defaults.initialVersionString,
        initialBuildNumber: BuildNumber = Defaults.initialBuildNumber,
        copyrightYear: UInt = Defaults.copyrightYear,
        copyrightEntity: String,
        _ customSections: String...
        ) -> Xcode.Project.Target.InfoPlist
    {
        var sections: [Section] = [
            .header,
            .basic(
                packageType: .framework,
                initialVersionString: initialVersionString,
                initialBuildNumber: initialBuildNumber
            ),
            .macOSFramework(
                copyrightYear: copyrightYear,
                copyrightEntity: copyrightEntity
            )
        ]

        sections += customSections.map{
            .custom($0)
        }

        sections += [
            .footer
        ]

        //---

        return .init(sections: sections)
    }

    static
    func macOSApp(
        initialVersionString: VersionString = Defaults.initialVersionString,
        initialBuildNumber: BuildNumber = Defaults.initialBuildNumber,
        copyrightYear: UInt = Defaults.copyrightYear,
        copyrightEntity: String,
        _ customSections: String...
        ) -> Xcode.Project.Target.InfoPlist
    {
        var sections: [Section] = [
            .header,
            .basic(
                packageType: .app,
                initialVersionString: initialVersionString,
                initialBuildNumber: initialBuildNumber
            ),
            .macOSApp(
                copyrightYear: copyrightYear,
                copyrightEntity: copyrightEntity
            )
        ]

        sections += customSections.map{
            .custom($0)
        }

        sections += [
            .footer
        ]

        //---

        return .init(sections: sections)
    }

    static
    func unitTests(
        initialVersionString: VersionString = Defaults.initialVersionString,
        initialBuildNumber: BuildNumber = Defaults.initialBuildNumber,
        _ customSections: String...
        ) -> Xcode.Project.Target.InfoPlist
    {
        var sections: [Section] = [
            .header,
            .basic(
                packageType: .tests,
                initialVersionString: initialVersionString,
                initialBuildNumber: initialBuildNumber
            )
        ]

        sections += customSections.map{
            .custom($0)
        }

        sections += [
            .footer
        ]

        //---

        return .init(sections: sections)
    }

}

// MARK: - Content rendering

public
extension Xcode.Project.Target.InfoPlist.Section
{
    func asIndentedText(
        with indentation: inout Indentation
        ) -> IndentedText
    {
        let result: String

        //---

        switch self
        {
        case .header:
            result = """
                <?xml version="1.0" encoding="UTF-8"?>
                <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
                <plist version="1.0">
                <dict>
                """

        case .basic(
            let packageType,
            let initialVersionString,
            let initialBuildNumber
            ):
            result = """

                <key>CFBundleDevelopmentRegion</key>
                <string>$(DEVELOPMENT_LANGUAGE)</string>
                <key>CFBundleExecutable</key>
                <string>$(EXECUTABLE_NAME)</string>
                <key>CFBundleIdentifier</key>
                <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
                <key>CFBundleInfoDictionaryVersion</key>
                <string>6.0</string>
                <key>CFBundleName</key>
                <string>$(PRODUCT_NAME)</string>
                <key>CFBundlePackageType</key>
                <string>\(packageType.rawValue)</string>
                <key>CFBundleShortVersionString</key>
                <string>\(initialVersionString)</string>
                <key>CFBundleVersion</key>
                <string>\(initialBuildNumber)</string>

                """

        case .iOSApp:
            result = """

                <key>LSRequiresIPhoneOS</key>
                <true/>
                <key>UILaunchStoryboardName</key>
                <string>LaunchScreen</string>
                <key>UIRequiredDeviceCapabilities</key>
                <array>
                <string>armv7</string>
                </array>
                <key>UISupportedInterfaceOrientations</key>
                <array>
                <string>UIInterfaceOrientationPortrait</string>
                </array>

                """

        case .macOSApp(
            let copyrightYear,
            let copyrightEntity
            ):
            result = """

                <key>CFBundleIconFile</key>
                <string></string>
                <key>LSMinimumSystemVersion</key>
                <string>$(MACOSX_DEPLOYMENT_TARGET)</string>
                <key>NSHumanReadableCopyright</key>
                <string>Copyright © \(copyrightYear) \(copyrightEntity). All rights reserved.</string>
                <key>NSMainNibFile</key>
                <string>MainMenu</string>
                <key>NSPrincipalClass</key>
                <string>NSApplication</string>

                """

        case .macOSFramework(
            let copyrightYear,
            let copyrightEntity
            ):
            result = """

                <key>NSHumanReadableCopyright</key>
                <string>Copyright © \(copyrightYear) \(copyrightEntity). All rights reserved.</string>
                <key>NSPrincipalClass</key>
                <string></string>

                """

        case .custom(
            let customSection
            ):
            result = """

                \(customSection)

                """

        case .footer:
            result = """
                </dict>
                </plist>
                """
        }

        //---

        return result.asIndentedText(with: &indentation)
    }
}
