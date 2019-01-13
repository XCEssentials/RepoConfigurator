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

/* internal */
extension Xcode.InfoPlist
{
    struct Sections
    {
        // MARK: Instance level members

        private
        let buffer: IndentedTextBuffer
        
        // MARK: Initializers

        init(
            buffer: IndentedTextBuffer
            )
        {
            self.buffer = buffer
        }
    }
}

// MARK: - Content rendering

/* internal */
extension Xcode.InfoPlist.Sections
{
    func header()
    {
        buffer <<< """
            <?xml version="1.0" encoding="UTF-8"?>
            <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
            <plist version="1.0">
            <dict>
            """
    }

    func basic(
        packageType: Xcode.InfoPlist.PackageType,
        initialVersionString: VersionString = Defaults.initialVersionString,
        initialBuildNumber: BuildNumber = Defaults.initialBuildNumber
        )
    {
        buffer <<< """

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
    }

    func iOSApp()
    {
        buffer <<< """

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
    }

    func macOSApp(
        copyrightYear: UInt = Spec.Product.copyrightYear,
        copyrightEntity: String
        )
    {
        buffer <<< """

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
    }

    func macOSFramework(
        copyrightYear: UInt = Spec.Product.copyrightYear,
        copyrightEntity: String
        )
    {
        buffer <<< """

            <key>NSHumanReadableCopyright</key>
            <string>Copyright © \(copyrightYear) \(copyrightEntity). All rights reserved.</string>
            <key>NSPrincipalClass</key>
            <string></string>
            """
    }

    func custom(
        _ customEntry: String
        )
    {
        buffer <<< """

            \(customEntry)
            """
    }

    func footer()
    {
        buffer <<< """

            </dict>
            </plist>
            """
    }
}
