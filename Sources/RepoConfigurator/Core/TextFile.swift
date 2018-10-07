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

// MARK: - Text File

public
protocol TextFile
{
    var fileContent: IndentedText { get }
}

public
extension TextFile
{
    var rendered: String
    {
        return fileContent
            .map{ "\($0)\($1)" }
            .joined(separator: "\n")
    }
}

// MARK: - ARBITRARY Named Text File

public
protocol ArbitraryNamedTextFile: TextFile {}

public
extension ArbitraryNamedTextFile
{
    func prepare(
        name: String,
        targetFolder: String,
        removeSpacesAtEOL: Bool = true,
        removeRepeatingEmptyLines: Bool = true
        ) -> PendingTextFile<Self>
    {
        return PendingTextFile(
            model: self,
            name: name,
            folder: targetFolder,
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

    func prepare(
        targetFolder: String,
        removeSpacesAtEOL: Bool = true,
        removeRepeatingEmptyLines: Bool = true
        ) -> PendingTextFile<Self>
    {
        return PendingTextFile(
            model: self,
            name: type(of: self).fileName,
            folder: targetFolder,
            shouldRemoveSpacesAtEOL: removeSpacesAtEOL,
            shouldRemoveRepeatingEmptyLines: removeRepeatingEmptyLines
        )
    }
}
