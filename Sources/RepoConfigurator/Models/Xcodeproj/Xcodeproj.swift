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

/**
 https://github.com/CocoaPods/Xcodeproj
 */
public
enum Xcodeproj: Gem
{
    public
    static
    let name: String = "xcodeproj"
}

//---

public
extension Xcodeproj
{
    /**
     https://github.com/CocoaPods/Xcodeproj/blob/c6c1c86459720e5dfbe406eb613a2d2de1607ee2/lib/xcodeproj/constants.rb#L125
     */
    public
    enum ProductType: String
    {
        case
            app                 = "com.apple.product-type.application",
            appExtension        = "com.apple.product-type.app-extension",
            bundle              = "com.apple.product-type.bundle",
            commandLineTool     = "com.apple.product-type.tool",
            dynamicLibrary      = "com.apple.product-type.library.dynamic",
            framework           = "com.apple.product-type.framework",
            messagesApp         = "com.apple.product-type.application.messages",
            messagesExtension   = "com.apple.product-type.app-extension.messages",
            messagesStickerPack = "com.apple.product-type.app-extension.messages-sticker-pack",
            staticLibrary       = "com.apple.product-type.library.static",
            tvAppExtension      = "com.apple.product-type.tv-app-extension",
            uiTestBundle        = "com.apple.product-type.bundle.ui-testing",
            unitTestBundle      = "com.apple.product-type.bundle.unit-test",
            watch2App           = "com.apple.product-type.application.watchapp2",
            watchApp            = "com.apple.product-type.application.watchapp",
            watchKit2Extension  = "com.apple.product-type.watchkit2-extension",
            watchKitExtension   = "com.apple.product-type.watchkit-extension",
            xpcService          = "com.apple.product-type.xpc-servic"

        static
        let octestBundle        = bundle
    }
}
