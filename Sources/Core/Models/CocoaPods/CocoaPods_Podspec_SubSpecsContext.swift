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
extension CocoaPods.Podspec
{
    struct SubSpecsContext
    {
        private
        let parentSpecVar: String

        private
        let specVar: String

        private
        let buffer: IndentedTextBuffer

        //internal
        init(
            parentSpecVar: String,
            specVar: String,
            buffer: IndentedTextBuffer
            )
        {
            self.parentSpecVar = parentSpecVar
            self.specVar = specVar
            self.buffer = buffer
        }
    }
}

// MARK: - Content rendering

public
extension CocoaPods.Podspec.SubSpecsContext
{
    func subSpec(
        _ specName: String,
        perPlatformSettings: (CocoaPods.Podspec.PerPlatformSettingsContext) -> Void
        )
    {
        // https://guides.cocoapods.org/syntax/podspec.html#subspec

        buffer.appendNewLine()
        
        buffer <<< """
            \(parentSpecVar).subspec '\(specName)' do |\(specVar)|

            """

        buffer.indentation.nest{

            perPlatformSettings(
                CocoaPods.Podspec.PerPlatformSettingsContext(
                    specVar: specVar,
                    buffer: buffer
                )
            )
        }

        buffer <<< """

            end # subspec '\(specName)'
            """
    }
}
