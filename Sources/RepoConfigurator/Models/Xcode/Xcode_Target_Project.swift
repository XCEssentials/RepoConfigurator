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
extension Xcode.Project
{
    public
    final
    class Target: Xcode.Target
    {
        // MARK: - Type level members

        public
        enum InternalType: String
        {
            case
                app = "application",
                framework = "framework",
                dynamicLibrary = "library.dynamic",
                staticLibrary = "library.static",
                bundle = "bundle",
                unitTest = "bundle.unit-test",
                uiTest = "bundle.ui-testing",
                appExtension = "app-extension",
                tool = "tool",
                watchApp = "application.watchapp",
                watchApp2 = "application.watchapp2",
                watchKitExtension = "watchkit-extension",
                watchKit2Extension = "watchkit2-extension",
                tvAppExtension = "tv-app-extension",
                messagesApp = "application.messages",
                appExtensionMessages = "app-extension.messages",
                appExtensionMessagesStickers = "app-extension.messages-sticker-pack",
                xpcService = "xpc-service"
        }

        // MARK: - Instance level members

        public
        let platform: OSIdentifier

        public
        let type: InternalType

        public private(set)
        var tests: [String: Target] = [:]

        public
        func unitTests(
            _ name: String = "Tests",
            _ configureTarget: (Target) -> Void
            )
        {
            tests[name] = .init(name, self.platform, .unitTest, { _ in })

            //---

            tests[name].map{

                $0.dependencies.otherTarget(self.name)

                if
                    self.type == .app
                {
                    $0.buildSettings.base.override(

                        // https://github.com/lyptt/struct/blob/master/examples/iOS_Application/project.yml#L115
                        "TEST_HOST" <<< "$(BUILT_PRODUCTS_DIR)/\(self.name).app/\(self.name)"
                    )
                }

                //---

                configureTarget($0)
            }
        }

        public
        func uiTests(
            _ name: String = "UITests",
            _ configureTarget: (Target) -> Void
            )
        {
            tests[name] = .init(name, self.platform, .uiTest, { _ in })

            //---

            tests[name].map{

                $0.dependencies.otherTarget(self.name)

                //---

                configureTarget($0)
            }
        }

        // MARK: - Initializers

        // internal
        required
        init(
            _ name: String,
            _ platform: OSIdentifier,
            _ type: InternalType,
            _ configureTarget: (Target) -> Void
            )
        {
            self.platform = platform
            self.type = type

            //---

            super.init(name)

            //---

            configureTarget(self)
        }
    }
}

// MARK: - Content rendering

public
extension OSIdentifier
{
    /**
     Platform ID for Struct config file.
     See [documentation](https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#platform).
     */
    var structId: String
    {
        switch self
        {
        case .iOS:
            return "ios"

        case .watchOS:
            return "watch"

        case .tvOS:
            return "tv"

        case .macOS:
            return "mac"
        }
    }
}

extension Xcode.Project.Target: TextFilePiece
{
    public
    func asIndentedText(
        with indentation: Indentation
        ) -> IndentedText
    {
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#targets

        //---

        let result: IndentedTextBuffer = .init(with: indentation)

        //---

        result <<< """
            \(name):
            """

        indentation.nest{

            // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#platform

            result <<< """
                platform: \(platform.structId)
                """

            //---

            // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#type

            result <<< """
                type: ":\(type.rawValue)"
                """

            //---

            result <<< self
                .renderCoreSettings(with: indentation)
        }

        //---

        result <<< tests.values.map{

            $0.asIndentedText(with: indentation)
        }

        //---

        return result.content
    }
}
