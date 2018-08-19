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
extension Xcode.Project.Variant
{
    public
    final
    class Target: Xcode.Target
    {
        // MARK: - Instance level members

        public private(set)
        var tests: [String: Target] = [:]

        public
        func unitTests(
            _ name: String = "Tests",
            _ configureTarget: (Target) -> Void
            )
        {
            tests[name] = .init(name, configureTarget)

            //---

            tests[name].map(configureTarget)
        }

        public
        func uiTests(
            _ name: String = "UITests",
            _ configureTarget: (Target) -> Void
            )
        {
            tests[name] = .init(name, { _ in })

            //---

            tests[name].map{

                $0.dependencies.otherTarget(self.name)
                configureTarget($0)
            }
        }

        // MARK: - Initializers

        //internal
        required
        init(
            _ name: String,
            _ configureTarget: (Target) -> Void
            )
        {
            super.init(name)

            //---

            configureTarget(self)
        }
    }
}

// MARK: - Content rendering

extension Xcode.Project.Variant.Target: TextFilePiece
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
