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

import Foundation

//---

public
extension Struct.Spec
{
    public
    struct PreGenerateScript: ArbitraryNamedTextFile
    {
        // MARK: Type level members

        public
        static
        let defaultSpecVar = "spec"

        public
        static
        let defaultFileName = "struct-pre-generate.rb"

        public
        struct Sections
        {
            private
            let buffer: IndentedTextBuffer
            
            //internal
            init(
                buffer: IndentedTextBuffer
                )
            {
                self.buffer = buffer
            }
        }

        // MARK: Instance level members

        public
        func prepareWithDefaultName(
            targetFolder: String,
            removeSpacesAtEOL: Bool = true,
            removeRepeatingEmptyLines: Bool = true
            ) -> PendingTextFile<PreGenerateScript>
        {
            return prepare(
                name: type(of: self).defaultFileName,
                targetFolder: targetFolder,
                removeSpacesAtEOL: removeSpacesAtEOL,
                removeRepeatingEmptyLines: removeRepeatingEmptyLines
            )
        }

        private
        var buffer = IndentedTextBuffer()
        
        public
        var fileContent: IndentedText
        {
            return buffer.content
        }

        // MARK: Initializers

        public
        init(
            specVar spec: String = defaultSpecVar,
            _ sections: (Sections) -> Void
            )
        {
            buffer <<< """
                # pre-generate Struct script
                # https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#lifecycle-hooks

                run do |\(spec)|

                """

            buffer.indentation.nest{

                sections(
                    Sections(
                        buffer: buffer
                    )
                )
            }

            buffer <<< """

                end
                """
        }
    }
}

// MARK: - Content rendering

public
extension Struct.Spec.PreGenerateScript.Sections
{
    func custom(
        _ content: String
        )
    {
        buffer <<< """

            \(content)
            """
    }
}

