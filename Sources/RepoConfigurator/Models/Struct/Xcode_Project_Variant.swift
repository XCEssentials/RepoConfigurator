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
    class Variant
    {
        // MARK: - Instance level members

        public
        let name: String

        public private(set)
        var targetsByName: [String: Target] = [:]

        public
        func targets(
            _ items: Target...
            )
        {
            items.forEach{

                targetsByName[$0.name] = $0
            }
        }

        // MARK: - Initializers

        public
        init(
            _ name: String,
            _ configure: ((Xcode.Project.Variant) -> Void)?
            )
        {
            self.name = name

            //---
            
            configure?(self)
        }
    }
}

// MARK: - Content rendering

extension Xcode.Project.Variant: TextFilePiece
{
    public
    func asIndentedText(
        with indentation: Indentation
        ) -> IndentedText
    {
        let result: IndentedTextBuffer = .init(with: indentation)

        //---

        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#variants
        
        result <<< """
            \(name):
            """

        indentation.nest{

            result <<< targetsByName.values.map{

                $0.asIndentedText(with: indentation)
            }
        }

        //---

        return result.content
    }
}
