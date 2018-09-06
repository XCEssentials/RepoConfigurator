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

        // MARK: Instance level members

        public
        let fileContent: IndentedText

        public
        func prepareWithDefaultName(
            targetFolder: String,
            removeSpacesAtEOL: Bool = true,
            removeRepeatingEmptyLines: Bool = true
            ) throws -> PendingTextFile<PreGenerateScript>
        {
            return try prepare(
                name: type(of: self).defaultFileName,
                targetFolder: targetFolder,
                removeSpacesAtEOL: removeSpacesAtEOL,
                removeRepeatingEmptyLines: removeRepeatingEmptyLines
            )
        }

        // MARK: Initializers

        public
        init(
            specVar spec: String = defaultSpecVar,
            _ sections: TextFileSection<Struct.Spec.PreGenerateScript>...
            )
        {
            let result = IndentedTextBuffer()

            //---

            result <<< """
                # pre-generate Struct script
                # https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#lifecycle-hooks

                run do |\(spec)|

                """

            result.indentation.nest{

                result <<< sections
            }

            result <<< """

                end
                """

            //---

            self.fileContent = result.content
        }
    }
}

// MARK: - Content rendering

public
extension TextFileSection
    where
    Context == Struct.Spec.PreGenerateScript
{
    static
    func custom(
        _ content: String
        ) -> TextFileSection<Context>
    {
        return .init{

            let result = IndentedTextBuffer(with: $0)

            //---

            result <<< """

                \(content)
                """

            //---

            return result.content
        }
    }
}

