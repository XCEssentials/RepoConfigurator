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
extension Xcode
{
    public
    final
    class Scripts
    {
        // MARK: - Instance level members

        public private(set)
        var regulars: [String] = []
        
        public
        func regular(_ paths: String...)
        {
            regulars.append(contentsOf: paths)
        }

        public private(set)
        var beforeBuilds: [String] = []
        
        public
        func beforeBuild(_ paths: String...)
        {
            beforeBuilds.append(contentsOf: paths)
        }

        public private(set)
        var afterBuilds: [String] = []
        
        public
        func afterBuild(_ paths: String...)
        {
            afterBuilds.append(contentsOf: paths)
        }

        // MARK: - Initializers

        public
        init() {}
    }
}

// MARK: - Content rendering

extension Xcode.Scripts: TextFilePiece
{
    public
    func asIndentedText(
        with indentation: Indentation
        ) -> IndentedText
    {
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#scripts

        // NOTE: paths to script files are going to be listed here;
        // according to the examples (see the URL above),
        // we don't need to put them in quotes.

        //---

        guard
            !regulars.isEmpty ||
            !beforeBuilds.isEmpty ||
            !afterBuilds.isEmpty
        else
        {
            return []
        }

        //---

        var result: [String] = []

        //---

        result <<< """
            scripts:
            """

        result <<< regulars.map{

            """
            -  \($0)
            """
        }

        result <<< """
                prebuild:
            """

        result <<< regulars.map{

            """
                -  \($0)
            """
        }

        result <<< """
                postbuild:
            """

        result <<< regulars.map{

            """
                -  \($0)
            """
        }

        //---

        return result
            .asMultiLine
            .asIndentedText(with: indentation)
    }
}
