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

import FileKit

//---

public
struct  LocalRepo
{
    public
    let location: Path
    
    public
    let context: String
    
    public
    var name: String
    {
        return location.fileName
    }
}

//---

public
extension LocalRepo
{
    public
    enum InitializationError: Error
    {
        case unableToDetectGitRepo
        case unableToDetectRepoParentFolder
    }
    
    static
    func current(
        shouldReport: Bool = false
        ) throws -> LocalRepo
    {
        let location = Path.currentRepoRoot
        
        let result: LocalRepo = try .init(
            location: location
                ?! InitializationError.unableToDetectGitRepo,
            context: location?.parent.fileName
                ?! InitializationError.unableToDetectRepoParentFolder
        )
        
        (shouldReport ? result.report() : ())
        
        //---
        
        return result
    }
    
    func report()
    {
        print("✅ Repo name: \(name)")
        print("✅ Repo location: \(location)")
        print("✅ Repo context: \(context)")
    }
}
