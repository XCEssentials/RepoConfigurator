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

// MARK: - MOBILE Targets

public
extension Mobile
{
    public
    final
    class App: Xcode.Target, XcodeTargetCore
    {
        // MARK: Type level members

        static
        public
        let platform: OSIdentifier = .iOS

        static
        public
        let targetType: Xcode.TargetType = .app

        // MARK: Instance level members

        public private(set)
        var dependentTargets: [String: TextFilePiece] = [:]

        public
        func addUnitTests(
            _ name: String,
            configure: (UnitTestingBundle) -> Void
            )
        {
            let newTarget: UnitTestingBundle = .init(name)

            //---

            dependentTargets[name] = newTarget

            //---

            newTarget.dependencies.otherTarget(self.name)

            newTarget.buildSettings.iOSAppTests()

            newTarget.buildSettings.base.override(

                "TEST_HOST" <<< "$(BUILT_PRODUCTS_DIR)/\(self.name).app/\(self.name)"
            )

            //---

            configure(newTarget)
        }

        public
        func addUITests(
            _ name: String,
            configure: (UITestingBundle) -> Void
            )
        {
            let newTarget: UITestingBundle = .init(name)

            //---

            dependentTargets[name] = newTarget

            //---

            newTarget.dependencies.otherTarget(self.name)

            newTarget.buildSettings.iOSAppUITests()

            newTarget.buildSettings.base.override(

                "TEST_TARGET_NAME" <<< "\(self.name)"
            )

            //---

            configure(newTarget)
        }

        // MARK: Initializers

        public
        required
        init(
            _ name: String,
            configure: (App) -> Void
            )
        {
            super.init(name)

            //---

            self.buildSettings.iOSApp()

            //---

            configure(self)
        }
    }

    public
    final
    class AppExtension: Xcode.Target, XcodeTargetCore
    {
        // MARK: Type level members

        static
        public
        let platform: OSIdentifier = .iOS

        static
        public
        let targetType: Xcode.TargetType = .appExtension

        // MARK: Initializers

        public
        required
        init(
            _ name: String,
            configure: (AppExtension) -> Void
            )
        {
            super.init(name)

            //---

            configure(self)
        }
    }

    public
    final
    class AppExtensionMessages: Xcode.Target, XcodeTargetCore
    {
        // MARK: Type level members

        static
        public
        let platform: OSIdentifier = .iOS

        static
        public
        let targetType: Xcode.TargetType = .appExtensionMessages

        // MARK: Initializers

        public
        required
        init(
            _ name: String,
            configure: (AppExtensionMessages) -> Void
            )
        {
            super.init(name)

            //---

            configure(self)
        }
    }

    public
    final
    class AppExtensionMessagesStickers: Xcode.Target, XcodeTargetCore
    {
        // MARK: Type level members

        static
        public
        let platform: OSIdentifier = .iOS

        static
        public
        let targetType: Xcode.TargetType = .appExtensionMessagesStickers

        // MARK: Initializers

        public
        required
        init(
            _ name: String,
            configure: (AppExtensionMessagesStickers) -> Void
            )
        {
            super.init(name)

            //---

            configure(self)
        }
    }

    public
    final
    class Framework: Xcode.Target, XcodeTargetCore
    {
        static
        public
        let platform: OSIdentifier = .iOS

        static
        public
        let targetType: Xcode.TargetType = .framework

        // MARK: Instance level members

        public private(set)
        var dependentTargets: [String: TextFilePiece] = [:]

        public
        func addUnitTests(
            _ name: String,
            _ configureTarget: (UnitTestingBundle) -> Void
            )
        {
            let newTarget: UnitTestingBundle = .init(name)

            //---

            dependentTargets[name] = newTarget

            //---

            newTarget.buildSettings.iOSFwkTests()

            newTarget.dependencies.otherTarget(self.name)

            //---

            configureTarget(newTarget)
        }

        // MARK: Initializers

        public
        required
        init(
            _ name: String,
            configure: (Framework) -> Void
            )
        {
            super.init(name)

            //---

            self.buildSettings.iOSFwk()

            //---

            configure(self)
        }
    }

    public
    final
    class MessagesApp: Xcode.Target, XcodeTargetCore
    {
        // MARK: Type level members

        static
        public
        let platform: OSIdentifier = .iOS

        static
        public
        let targetType: Xcode.TargetType = .messagesApp

        // MARK: Initializers

        public
        required
        init(
            _ name: String,
            configure: (MessagesApp) -> Void
            )
        {
            super.init(name)

            //---

            configure(self)
        }
    }

    public
    final
    class StaticLibrary: Xcode.Target, XcodeTargetCore
    {
        // MARK: Type level members

        static
        public
        let platform: OSIdentifier = .iOS

        static
        public
        let targetType: Xcode.TargetType = .staticLibrary

        // MARK: Initializers

        public
        required
        init(
            _ name: String,
            configure: (StaticLibrary) -> Void
            )
        {
            super.init(name)

            //---

            configure(self)
        }
    }

    public
    final
    class UITestingBundle: Xcode.Target, XcodeTargetCore
    {
        // MARK: Type level members

        static
        public
        let platform: OSIdentifier = .iOS

        static
        public
        let targetType: Xcode.TargetType = .uiTest
    }

    public
    final
    class UnitTestingBundle: Xcode.Target, XcodeTargetCore
    {
        // MARK: Type level members

        static
        public
        let platform: OSIdentifier = .iOS

        static
        public
        let targetType: Xcode.TargetType = .unitTest
    }
}

// MARK: - WATCH Targets

public
extension Watch
{
    public
    final
    class Framework: Xcode.Target, XcodeTargetCore
    {
        static
        public
        let platform: OSIdentifier = .watchOS

        static
        public
        let targetType: Xcode.TargetType = .framework

        // MARK: Initializers

        public
        required
        init(
            _ name: String,
            configure: (Framework) -> Void
            )
        {
            super.init(name)

            //---

            self.buildSettings.watchOSFwk()

            //---

            configure(self)
        }
    }

    public
    final
    class StaticLibrary: Xcode.Target, XcodeTargetCore
    {
        // MARK: Type level members

        static
        public
        let platform: OSIdentifier = .watchOS

        static
        public
        let targetType: Xcode.TargetType = .staticLibrary

        // MARK: Initializers

        public
        required
        init(
            _ name: String,
            configure: (StaticLibrary) -> Void
            )
        {
            super.init(name)

            //---

            configure(self)
        }
    }

    public
    final
    class WatchApp: Xcode.Target, XcodeTargetCore
    {
        // MARK: Type level members

        static
        public
        let platform: OSIdentifier = .watchOS

        static
        public
        let targetType: Xcode.TargetType = .watchApp

        // MARK: Initializers

        public
        required
        init(
            _ name: String,
            configure: (WatchApp) -> Void
            )
        {
            super.init(name)

            //---

            self.buildSettings.watchOSApp()

            //---

            configure(self)
        }
    }

    public
    final
    class WatchApp2: Xcode.Target, XcodeTargetCore
    {
        // MARK: Type level members

        static
        public
        let platform: OSIdentifier = .watchOS

        static
        public
        let targetType: Xcode.TargetType = .watchApp2

        // MARK: Initializers

        public
        required
        init(
            _ name: String,
            configure: (WatchApp2) -> Void
            )
        {
            super.init(name)

            //---

            self.buildSettings.watchOSApp()

            //---

            configure(self)
        }
    }

    public
    final
    class WatchKitExtension: Xcode.Target, XcodeTargetCore
    {
        // MARK: Type level members

        static
        public
        let platform: OSIdentifier = .watchOS

        static
        public
        let targetType: Xcode.TargetType = .watchKitExtension

        // MARK: Initializers

        public
        required
        init(
            _ name: String,
            configure: (WatchKitExtension) -> Void
            )
        {
            super.init(name)

            //---

            configure(self)
        }
    }

    public
    final
    class WatchKit2Extension: Xcode.Target, XcodeTargetCore
    {
        // MARK: Type level members

        static
        public
        let platform: OSIdentifier = .watchOS

        static
        public
        let targetType: Xcode.TargetType = .watchKit2Extension

        // MARK: Initializers

        public
        required
        init(
            _ name: String,
            configure: (WatchKit2Extension) -> Void
            )
        {
            super.init(name)

            //---

            configure(self)
        }
    }
}

// MARK: - TV Targets

public
extension TV
{
    public
    final
    class App: Xcode.Target, XcodeTargetCore
    {
        // MARK: Type level members

        static
        public
        let platform: OSIdentifier = .tvOS

        static
        public
        let targetType: Xcode.TargetType = .app

        // MARK: Instance level members

        public private(set)
        var dependentTargets: [String: TextFilePiece] = [:]

        public
        func addUnitTests(
            _ name: String,
            configure: (UnitTestingBundle) -> Void
            )
        {
            let newTarget: UnitTestingBundle = .init(name)

            //---

            dependentTargets[name] = newTarget

            //---

            newTarget.dependencies.otherTarget(self.name)

            newTarget.buildSettings.tvOSAppTests()

            newTarget.buildSettings.base.override(

                "TEST_HOST" <<< "$(BUILT_PRODUCTS_DIR)/\(self.name).app/\(self.name)"
            )

            //---

            configure(newTarget)
        }

        public
        func addUITests(
            _ name: String,
            configure: (UITestingBundle) -> Void
            )
        {
            let newTarget: UITestingBundle = .init(name)

            //---

            dependentTargets[name] = newTarget

            //---

            newTarget.dependencies.otherTarget(self.name)

            newTarget.buildSettings.tvOSAppUITests()

            newTarget.buildSettings.base.override(

                "TEST_TARGET_NAME" <<< "\(self.name)"
            )

            //---

            configure(newTarget)
        }

        // MARK: Initializers

        public
        required
        init(
            _ name: String,
            configure: (App) -> Void
            )
        {
            super.init(name)

            //---

            self.buildSettings.tvOSApp()

            //---

            configure(self)
        }
    }

    public
    final
    class AppExtension: Xcode.Target, XcodeTargetCore
    {
        // MARK: Type level members

        static
        public
        let platform: OSIdentifier = .tvOS

        static
        public
        let targetType: Xcode.TargetType = .tvAppExtension

        public
        required
        init(
            _ name: String,
            configure: (AppExtension) -> Void
            )
        {
            super.init(name)

            //---

            configure(self)
        }
    }

    public
    final
    class Framework: Xcode.Target, XcodeTargetCore
    {
        static
        public
        let platform: OSIdentifier = .tvOS

        static
        public
        let targetType: Xcode.TargetType = .framework

        // MARK: Instance level members

        public private(set)
        var dependentTargets: [String: TextFilePiece] = [:]

        public
        func addUnitTests(
            _ name: String,
            _ configureTarget: (UnitTestingBundle) -> Void
            )
        {
            let newTarget: UnitTestingBundle = .init(name)

            //---

            dependentTargets[name] = newTarget

            //---

            newTarget.buildSettings.tvOSFwkTests()

            newTarget.dependencies.otherTarget(self.name)

            //---

            configureTarget(newTarget)
        }

        // MARK: Initializers

        public
        required
        init(
            _ name: String,
            configure: (Framework) -> Void
            )
        {
            super.init(name)

            //---

            self.buildSettings.tvOSFwk()

            //---

            configure(self)
        }
    }

    public
    final
    class StaticLibrary: Xcode.Target, XcodeTargetCore
    {
        // MARK: Type level members

        static
        public
        let platform: OSIdentifier = .tvOS

        static
        public
        let targetType: Xcode.TargetType = .staticLibrary

        public
        required
        init(
            _ name: String,
            configure: (StaticLibrary) -> Void
            )
        {
            super.init(name)

            //---

            configure(self)
        }
    }

    public
    final
    class UITestingBundle: Xcode.Target, XcodeTargetCore
    {
        // MARK: Type level members

        static
        public
        let platform: OSIdentifier = .tvOS

        static
        public
        let targetType: Xcode.TargetType = .uiTest
    }

    public
    final
    class UnitTestingBundle: Xcode.Target, XcodeTargetCore
    {
        // MARK: Type level members

        static
        public
        let platform: OSIdentifier = .tvOS

        static
        public
        let targetType: Xcode.TargetType = .unitTest
    }
}

// MARK: - DESKTOP Targets

public
extension Desktop
{
    public
    final
    class App: Xcode.Target, XcodeTargetCore
    {
        // MARK: Type level members

        static
        public
        let platform: OSIdentifier = .macOS

        static
        public
        let targetType: Xcode.TargetType = .app

        // MARK: Instance level members

        public private(set)
        var dependentTargets: [String: TextFilePiece] = [:]

        public
        func addUnitTests(
            _ name: String,
            configure: (UnitTestingBundle) -> Void
            )
        {
            let newTarget: UnitTestingBundle = .init(name)

            //---

            dependentTargets[name] = newTarget

            //---

            newTarget.dependencies.otherTarget(self.name)

            newTarget.buildSettings.macOSAppTests()

            newTarget.buildSettings.base.override(

                // https://github.com/lyptt/struct/blob/master/examples/iOS_Application/project.yml#L107
                "TEST_HOST" <<< "$(BUILT_PRODUCTS_DIR)/\(self.name).app/Contents/MacOS/\(self.name)"
            )

            //---

            configure(newTarget)
        }

        public
        func addUITests(
            _ name: String,
            configure: (UITestingBundle) -> Void
            )
        {
            let newTarget: UITestingBundle = .init(name)

            //---

            dependentTargets[name] = newTarget

            //---

            newTarget.dependencies.otherTarget(self.name)

            newTarget.buildSettings.macOSAppUITests()

            newTarget.buildSettings.base.override(

                "TEST_TARGET_NAME" <<< "\(self.name)"
            )

            //---

            configure(newTarget)
        }

        // MARK: Initializers

        public
        required
        init(
            _ name: String,
            configure: (App) -> Void
            )
        {
            super.init(name)

            //---

            self.buildSettings.macOSApp()

            //---

            configure(self)
        }
    }

    public
    final
    class AppExtension: Xcode.Target, XcodeTargetCore
    {
        // MARK: Type level members

        static
        public
        let platform: OSIdentifier = .macOS

        static
        public
        let targetType: Xcode.TargetType = .appExtension

        // MARK: Initializers

        public
        required
        init(
            _ name: String,
            configure: (AppExtension) -> Void
            )
        {
            super.init(name)

            //---

            configure(self)
        }
    }

    public
    final
    class Bundle: Xcode.Target, XcodeTargetCore
    {
        // MARK: Type level members

        static
        public
        let platform: OSIdentifier = .macOS

        static
        public
        let targetType: Xcode.TargetType = .bundle

        // MARK: Initializers

        public
        required
        init(
            _ name: String,
            configure: (Bundle) -> Void
            )
        {
            super.init(name)

            //---

            configure(self)
        }
    }

    public
    final
    class CommandLineTool: Xcode.Target, XcodeTargetCore
    {
        // MARK: Type level members

        static
        public
        let platform: OSIdentifier = .macOS

        static
        public
        let targetType: Xcode.TargetType = .tool

        // MARK: Initializers

        public
        required
        init(
            _ name: String,
            configure: (CommandLineTool) -> Void
            )
        {
            super.init(name)

            //---

            configure(self)
        }
    }

    public
    final
    class DynamicLibrary: Xcode.Target, XcodeTargetCore
    {
        // MARK: Type level members

        static
        public
        let platform: OSIdentifier = .macOS

        static
        public
        let targetType: Xcode.TargetType = .dynamicLibrary

        // MARK: Initializers

        public
        required
        init(
            _ name: String,
            configure: (DynamicLibrary) -> Void
            )
        {
            super.init(name)

            //---

            configure(self)
        }
    }

    public
    final
    class Framework: Xcode.Target, XcodeTargetCore
    {
        static
        public
        let platform: OSIdentifier = .macOS

        static
        public
        let targetType: Xcode.TargetType = .framework

        // MARK: Instance level members

        public private(set)
        var dependentTargets: [String: TextFilePiece] = [:]

        public
        func addUnitTests(
            _ name: String,
            _ configureTarget: (UnitTestingBundle) -> Void
            )
        {
            let newTarget: UnitTestingBundle = .init(name)

            //---

            dependentTargets[name] = newTarget

            //---

            newTarget.buildSettings.macOSFwkTests()

            newTarget.dependencies.otherTarget(self.name)

            //---

            configureTarget(newTarget)
        }

        // MARK: Initializers

        public
        required
        init(
            _ name: String,
            configure: (Framework) -> Void
            )
        {
            super.init(name)

            //---

            self.buildSettings.macOSFwk()

            //---

            configure(self)
        }
    }

    public
    final
    class StaticLibrary: Xcode.Target, XcodeTargetCore
    {
        // MARK: Type level members

        static
        public
        let platform: OSIdentifier = .macOS

        static
        public
        let targetType: Xcode.TargetType = .staticLibrary

        // MARK: Initializers

        public
        required
        init(
            _ name: String,
            configure: (StaticLibrary) -> Void
            )
        {
            super.init(name)

            //---

            configure(self)
        }
    }

    public
    final
    class UITestingBundle: Xcode.Target, XcodeTargetCore
    {
        // MARK: Type level members

        static
        public
        let platform: OSIdentifier = .macOS

        static
        public
        let targetType: Xcode.TargetType = .uiTest
    }

    public
    final
    class UnitTestingBundle: Xcode.Target, XcodeTargetCore
    {
        // MARK: Type level members

        static
        public
        let platform: OSIdentifier = .macOS

        static
        public
        let targetType: Xcode.TargetType = .unitTest
    }

    public
    final
    class XPCService: Xcode.Target, XcodeTargetCore
    {
        // MARK: Type level members

        static
        public
        let platform: OSIdentifier = .macOS

        static
        public
        let targetType: Xcode.TargetType = .xpcService
    }
}
