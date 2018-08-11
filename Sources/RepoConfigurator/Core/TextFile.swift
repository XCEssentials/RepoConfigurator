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

// MARK: - Text File

public
protocol TextFile
{
    var fileContent: [IndentedTextGetter] { get }
}

// MARK: - ARBITRARY Named Text File

public
protocol ArbitraryNamedTextFile: TextFile {}

public
extension ArbitraryNamedTextFile
{
    func prepare(
        name: String,
        targetFolder: URL,
        removeSpacesAtEOL: Bool = true,
        removeRepeatingEmptyLines: Bool = true
        ) -> RawTextFile<Self>
    {
        return RawTextFile(
            model: self,
            name: name,
            targetFolder: targetFolder,
            shouldRemoveSpacesAtEOL: removeSpacesAtEOL,
            shouldRemoveRepeatingEmptyLines: removeRepeatingEmptyLines
        )
    }
}

// MARK: - FIXED Named Text File

public
protocol FixedNameTextFile: TextFile
{
    static
    var fileName: String { get }
}

public
extension FixedNameTextFile
{
    static
    var fileName: String
    {
        // by default return intrinsic file name type based on type name

        return String
            .init(describing: self)
            .components(
                separatedBy: .whitespacesAndNewlines
            )
            .first
            ??
        ""
    }

    var fileName: String
    {
        return Self.fileName
    }

    func prepare(
        targetFolder: URL,
        removeSpacesAtEOL: Bool = true,
        removeRepeatingEmptyLines: Bool = true
        ) -> RawTextFile<Self>
    {
        return RawTextFile(
            model: self,
            name: type(of: self).fileName,
            targetFolder: targetFolder,
            shouldRemoveSpacesAtEOL: removeSpacesAtEOL,
            shouldRemoveRepeatingEmptyLines: removeRepeatingEmptyLines
        )
    }
}

// MARK: - Text File Piece

public
protocol TextFilePiece
{
    func asIndentedText(
        with indentation: inout Indentation
        ) -> IndentedText
}

// MARK: - CONFIGURABLE Named Text File

public
protocol ConfigurableTextFile: TextFile
{
    associatedtype Section: TextFilePiece

    var fileContent: [IndentedTextGetter] { get set }
}

public
extension ConfigurableTextFile
{
    func extend(
        with otherSections: [Self.Section]
        ) -> Self
    {
        var result = self

        //---

        result.fileContent += otherSections.map{ $0.asIndentedText }

        //---

        return result
    }

    func extend(
        _ otherSections: Self.Section...
        ) -> Self
    {
        return self.extend(with: otherSections)
    }
}
