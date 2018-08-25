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
extension Xcode.Target
{
    public
    final
    class InfoPlist: ArbitraryNamedTextFile
    {
        // MARK: Type level members

        public
        enum PackageType: String
        {
            case app = "APPL"
            case framework = "FMWK"
            case tests = "BNDL"
        }

        // MARK: Instance level members

        public
        let fileContent: IndentedText

        // MARK: Initializers

        public
        init(
            for packageType: PackageType,
            initialVersionString: VersionString = Defaults.initialVersionString,
            initialBuildNumber: BuildNumber = Defaults.initialBuildNumber,
            preset: Preset?,
            _ otherEntries: String...
            )
        {
            let result = IndentedTextBuffer()

            //---

            typealias Section = TextFileSection<Xcode.Target.InfoPlist>

            result <<< [

                Section.header(),
                Section.basic(
                    packageType: packageType,
                    initialVersionString: initialVersionString,
                    initialBuildNumber: initialBuildNumber
                )
            ]

            switch preset
            {
            case .some(.iOS) where packageType == .app:
                result <<< Section.iOSApp()

            case .some(.macOS(let year, let entity)) where packageType == .app:
                result <<< Section.macOSApp(
                    copyrightYear: year,
                    copyrightEntity: entity
                )

            case .some(.macOS(let year, let entity)) where packageType == .framework:
                result <<< Section.macOSFramework(
                    copyrightYear: year,
                    copyrightEntity: entity
                )

            default:
                break
            }

            result <<< otherEntries

            result <<< Section.footer()

            //---

            fileContent = result.content
        }
    }
}

// MARK: - Presets

public
extension Xcode.Target.InfoPlist
{
    public
    enum Preset
    {
        case iOS

        case macOS(
            copyrightYear: UInt,
            copyrightEntity: String
        )

        //---

        static
        func macOSWithCurrentYear(
            copyrightEntity: String
            ) -> Preset
        {
            return .macOS(
                copyrightYear: Defaults.copyrightYear,
                copyrightEntity: copyrightEntity
            )
        }
    }
}

// MARK: - Content rendering

extension TextFileSection
    where
    Context == Xcode.Target.InfoPlist
{
    static
    func header(
        ) -> TextFileSection<Context>
    {
        return .init{ """
            <?xml version="1.0" encoding="UTF-8"?>
            <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
            <plist version="1.0">
            <dict>
            """
            .asIndentedText(with: $0)
        }
    }

    static
    func basic(
        packageType: Xcode.Target.InfoPlist.PackageType,
        initialVersionString: VersionString = Defaults.initialVersionString,
        initialBuildNumber: BuildNumber = Defaults.initialBuildNumber
        ) -> TextFileSection<Context>
    {
        return .init{ """

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
            .asIndentedText(with: $0)
        }
    }

    static
    func iOSApp(
        ) -> TextFileSection<Context>
    {
        return .init{ """

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
            .asIndentedText(with: $0)
        }
    }

    static
    func macOSApp(
        copyrightYear: UInt = Defaults.copyrightYear,
        copyrightEntity: String
        ) -> TextFileSection<Context>
    {
        return .init{ """

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
            .asIndentedText(with: $0)
        }
    }

    static
    func macOSFramework(
        copyrightYear: UInt = Defaults.copyrightYear,
        copyrightEntity: String
        ) -> TextFileSection<Context>
    {
        return .init{ """

            <key>NSHumanReadableCopyright</key>
            <string>Copyright © \(copyrightYear) \(copyrightEntity). All rights reserved.</string>
            <key>NSPrincipalClass</key>
            <string></string>
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

            \(customEntry)
            """
            .asIndentedText(with: $0)
        }
    }

    static
    func footer(
        ) -> TextFileSection<Context>
    {
        return .init{ """

            </dict>
            </plist>
            """
            .asIndentedText(with: $0)
        }
    }
}
