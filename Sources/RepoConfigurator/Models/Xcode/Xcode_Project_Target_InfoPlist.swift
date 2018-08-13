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
extension Xcode.Project.Target
{
    public
    struct InfoPlist: ArbitraryNamedTextFile
    {
        // MARK: - Type level members

        public
        enum PackageType: String
        {
            case app = "APPL"
            case framework = "FMWK"
            case tests = "BNDL"
        }

        //internal
        enum ContentSection
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
        let fileContent: [IndentedTextGetter]
    }
}

// MARK: - Presets

public
extension Xcode.Project.Target.InfoPlist
{
    static
    func custom(
        entries: String...
        ) -> Xcode.Project.Target.InfoPlist
    {
        var sections: [ContentSection] = []

        //---

        sections += [
            .header
        ]

        sections += entries.map{

            .custom($0)
        }

        sections += [

            .footer
        ]

        //---

        return .init(
            fileContent: sections.map{ $0.asIndentedText }
        )
    }

    static
    func iOSFramework(
        initialVersionString: VersionString = Defaults.initialVersionString,
        initialBuildNumber: BuildNumber = Defaults.initialBuildNumber,
        _ customEntries: String...
        ) -> Xcode.Project.Target.InfoPlist
    {
        var sections: [ContentSection] = []

        //---

        sections += [

            .header,
            .basic(
                packageType: .framework,
                initialVersionString: initialVersionString,
                initialBuildNumber: initialBuildNumber
            )
        ]

        sections += customEntries.map{

            .custom($0)
        }

        sections += [
            .footer
        ]

        //---

        return .init(
            fileContent: sections.map{ $0.asIndentedText }
        )
    }

    static
    func iOSApp(
        initialVersionString: VersionString = Defaults.initialVersionString,
        initialBuildNumber: BuildNumber = Defaults.initialBuildNumber,
        _ customEntries: String...
        ) -> Xcode.Project.Target.InfoPlist
    {
        var sections: [ContentSection] = []

        //---

        sections += [

            .header,
            .basic(
                packageType: .app,
                initialVersionString: initialVersionString,
                initialBuildNumber: initialBuildNumber
            ),
            .iOSApp
        ]

        sections += customEntries.map{

            .custom($0)
        }

        sections += [
            .footer
        ]

        //---

        return .init(
            fileContent: sections.map{ $0.asIndentedText }
        )
    }

    static
    func macOSFramework(
        initialVersionString: VersionString = Defaults.initialVersionString,
        initialBuildNumber: BuildNumber = Defaults.initialBuildNumber,
        copyrightYear: UInt = Defaults.copyrightYear,
        copyrightEntity: String,
        _ customEntries: String...
        ) -> Xcode.Project.Target.InfoPlist
    {
        var sections: [ContentSection] = []

        //---

        sections += [

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

        sections += customEntries.map{

            .custom($0)
        }

        sections += [
            .footer
        ]

        //---

        return .init(
            fileContent: sections.map{ $0.asIndentedText }
        )
    }

    static
    func macOSApp(
        initialVersionString: VersionString = Defaults.initialVersionString,
        initialBuildNumber: BuildNumber = Defaults.initialBuildNumber,
        copyrightYear: UInt = Defaults.copyrightYear,
        copyrightEntity: String,
        _ customEntries: String...
        ) -> Xcode.Project.Target.InfoPlist
    {
        var sections: [ContentSection] = []

        //---

        sections += [

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

        sections += customEntries.map{

            .custom($0)
        }

        sections += [
            .footer
        ]

        //---

        return .init(
            fileContent: sections.map{ $0.asIndentedText }
        )
    }

    static
    func unitTests(
        initialVersionString: VersionString = Defaults.initialVersionString,
        initialBuildNumber: BuildNumber = Defaults.initialBuildNumber,
        _ customEntries: String...
        ) -> Xcode.Project.Target.InfoPlist
    {
        var sections: [ContentSection] = []

        //---

        sections += [

            .header,
            .basic(
                packageType: .tests,
                initialVersionString: initialVersionString,
                initialBuildNumber: initialBuildNumber
            )
        ]

        sections += customEntries.map{

            .custom($0)
        }

        sections += [
            .footer
        ]

        //---

        return .init(
            fileContent: sections.map{ $0.asIndentedText }
        )
    }
}

// MARK: - Content rendering

extension Xcode.Project.Target.InfoPlist.ContentSection: TextFilePiece
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
