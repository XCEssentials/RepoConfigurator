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
struct RawTextFile<T: TextFile>
{
    // MARK: Type level members

    public
    enum IfFileExistsWritePolicy
    {
        case doNotWrite
        case override
    }

    // MARK: Instance level members

    public
    let model: T

    /**
     Desired full path to file in file system.
     */
    public
    let targetLocation: URL

    public
    let shouldRemoveSpacesAtEOL: Bool

    public
    let shouldRemoveRepeatingEmptyLines: Bool

    public
    var name: String
    {
        return targetLocation.lastPathComponent
    }

    //---

    public
    var content: String
    {
        var result = model.rendered

        //---

        if
            shouldRemoveSpacesAtEOL
        {
            result = result
                .recursiveReplacingOccurrences(of: " \n", with: "\n")
        }

        if
            shouldRemoveRepeatingEmptyLines
        {
            result = result
                .recursiveReplacingOccurrences(of: "\n\n\n", with: "\n\n")
        }

        //---

        return result
    }

    //---

    public
    func writeToFileSystem(
        ifFileExists: IfFileExistsWritePolicy = .override
        ) throws -> Bool
    {
        // lets makre sure folders up to this file exists

        let pathToFolder = targetLocation
            .deletingLastPathComponent()
            .path

        if
            !FileManager
                .default
                .fileExists(atPath: pathToFolder)
        {
            try FileManager
                .default
                .createDirectory(
                    atPath: pathToFolder,
                    withIntermediateDirectories: true,
                    attributes: nil
                )
        }

        //---

        if
            (ifFileExists == .override) ||
            !FileManager.default.fileExists(atPath: targetLocation.path)
        {
            try content.write(
                to: targetLocation,
                atomically: true,
                encoding: .utf8
            )

            return true
        }
        else
        {
            return false
        }
    }
}

//---

fileprivate
extension String
{
    func recursiveReplacingOccurrences(
        of wanted: String,
        with replacement: String
        ) -> String
    {
        var result = self

        //---

        var previousResult: String

        repeat
        {
            previousResult = result
            result = result.replacingOccurrences(of: wanted, with: replacement)
        }
            while
            result != previousResult

        //---

        return result
    }
}
