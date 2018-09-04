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
protocol XcodeTargetCore: TextFilePiece
{
    static
    var platform: OSIdentifier { get }

    /**
     https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#type
     */
    static
    var targetType: Xcodeproj.ProductType { get }

    var name: String { get }

    var dependentTargets: [String: TextFilePiece] { get }

    func renderCoreSettings(
        with indentation: Indentation
        ) -> IndentedText
}

// MARK: - Defaults

public
extension XcodeTargetCore
{
    var dependentTargets: [String: TextFilePiece]
    {
        return [:]
    }
}

// MARK: - Content rendering

extension XcodeTargetCore // : TextFilePiece
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
                platform: \(type(of: self).platform.structId)
                """

            //---

            // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#type

            result <<< """
                type: ":\(type(of: self).targetType.structId)"
                """

            //---

            result <<< self
                .renderCoreSettings(with: indentation)
        }

        //---

        return result.content
    }
}
