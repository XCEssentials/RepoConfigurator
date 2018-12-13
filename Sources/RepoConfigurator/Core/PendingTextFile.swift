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

import FileKit

//---

public
struct PendingTextFile<T: TextFile>
{
    // MARK: Type level members

    public
    enum IfFileExistsWritePolicy
    {
        case doNotWrite
        case override

        //---

        public
        static
        var skip: IfFileExistsWritePolicy
        {
            return .doNotWrite
        }
    }

    // MARK: Instance level members

    public
    let model: T

    public
    let location: Path

    public
    let shouldRemoveSpacesAtEOL: Bool

    public
    let shouldRemoveRepeatingEmptyLines: Bool

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

    @discardableResult
    public
    func writeToFileSystem(
        createIntermediateDirectories: Bool = true,
        ifFileExists: IfFileExistsWritePolicy = .override
        ) throws -> Bool
    {
        do
        {
            try location
                .parent
                .createDirectory(
                    withIntermediateDirectories: createIntermediateDirectories
            )
            
            //---
            
            if
                (ifFileExists == .override) ||
                !location.exists
            {
                try content.write(
                    to: location.url,
                    atomically: true,
                    encoding: .utf8
                )
                
                print("📄 Written file: \(location.url.absoluteString)")
                
                return true
            }
            else
            {
                print("⏭ SKIPPED file: \(location.url.absoluteString)")
                
                return false
            }
        }
        catch
        {
            print("❌ Failed to write file: \(location.url.absoluteString).")
            
            throw error
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
