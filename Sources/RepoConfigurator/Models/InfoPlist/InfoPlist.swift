public
struct InfoPlist: ArbitraryNamedFile
{
    public
    enum PackageType: String
    {
        case app = "APPL"
        case framework = "FMWK"
        case tests = "BNDL"
    }

    //---

    public
    let fileName: String

    //---

    public
    let packageType: PackageType

    public
    let initialVersionString: VersionString

    public
    let initialBuildNumber: BuildNumber

    //---

    public
    var fileContent: IndentedText
    {
        return """
            <?xml version="1.0" encoding="UTF-8"?>
            <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
            <plist version="1.0">
            <dict>

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

            </dict>
            </plist>
            """
            .asIndentedText()
    }
}

//---

public
struct InfoPlist_macOS: ArbitraryNamedFile
{
    public
    enum PackageType: String
    {
        case app = "APPL"
        case framework = "FMWK"
        case tests = "BNDL"
    }

    //---

    public
    let fileName: String

    //---

    public
    let packageType: PackageType

    public
    let initialVersionString: VersionString

    public
    let initialBuildNumber: BuildNumber

    public
    let copyrightYear: UInt

    public
    let copyrightEntity: String

    //---

    public
    var fileContent: IndentedText
    {
        return """
            <?xml version="1.0" encoding="UTF-8"?>
            <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
            <plist version="1.0">
            <dict>

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

            </dict>
            </plist>
            """
            .asIndentedText()
    }
}
