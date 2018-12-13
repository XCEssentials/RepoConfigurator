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
extension Path
{
    static
    var iCloudDrive: Path?
    {
        guard
            let userLibraryDir: URL = try? FileManager.default.url(
                for: .libraryDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            )
        else
        {
            return nil
        }
        
        //---
        
        guard
            let resultPrefix = Path(url: userLibraryDir)
        else
        {
            return nil
        }
        
        //---
        
        return resultPrefix
            + "Mobile Documents"
            + "com~apple~CloudDocs"
    }
    
    var isGitRepoRoot: Bool
    {
        return children().contains{
            
            $0.isDirectory && ($0.components.last == ".git")
        }
    }
    
    static
    var currentRepoRoot: Path?
    {
        var maybeResult: Path? = .current
        
        //---
        
        repeat
        {
            switch maybeResult
            {
            case let .some(path):
                if
                    path.isGitRepoRoot
                {
                    return path
                }
                else
                {
                    maybeResult = path.parent // and keep looking...
                }
                
            default:
                return nil
            }
        }
        while true
    }
}

//---

extension Path: ExpressibleByArrayLiteral
{
    public
    init(arrayLiteral elements: String...)
    {
        self.init(elements.joined(separator: Path.separator))
    }
}

