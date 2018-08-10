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

extension Xcode.Project.Target
{
    public
    enum InternalType: String
    {
        case
            app = ":application",
            framework = ":framework",
            dynamicLibrary = ":library.dynamic",
            staticLibrary = ":library.static",
            bundle = ":bundle",
            unitTest = ":bundle.unit-test",
            uiTest = ":bundle.ui-testing",
            appExtension = ":app-extension",
            tool = ":tool",
            watchApp = ":application.watchapp",
            watchApp2 = ":application.watchapp2",
            watchKitExtension = ":watchkit-extension",
            watchKit2Extension = ":watchkit2-extension",
            tvAppExtension = ":tv-app-extension",
            messagesApp = ":application.messages",
            appExtensionMessages = ":app-extension.messages",
            appExtensionMessagesStickers = ":app-extension.messages-sticker-pack",
            xpcService = ":xpc-service"
    }
}
