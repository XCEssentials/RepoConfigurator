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

import PathKit
import ShellOut

//---

public
extension Spec
{
    struct  LocalRepo
    {
        public
        let location: Path
        
        public
        let context: String
        
        public
        var name: String
        {
            return location.lastComponentWithoutExtension
        }
    }
}

//---

public
extension Spec.LocalRepo
{
    enum InitializationError: Error
    {
        case gitRepoAutoDetectionFailed
        case repoParentFolderAutoDetectionFailed
    }
    
    static
    func current(
        shouldReport: Bool = false
        ) throws -> Spec.LocalRepo
    {
        let location = try Path.currentRepoRoot()
            ?! InitializationError.gitRepoAutoDetectionFailed
        
        let context = try location.parent().lastComponentWithoutExtension
            ?! InitializationError.repoParentFolderAutoDetectionFailed
        
        //---
        
        let result: Spec.LocalRepo = .init(
            location: location,
            context: context
        )
        
        //---
        
        if
            shouldReport
        {
            result.report()
        }
        
        return result
    }
    
    func report()
    {
        print("✅ Repo name: \(name)")
        print("✅ Repo location: \(location)")
        print("✅ Repo context: \(context)")
    }
    
    enum CurrentBranchDetectionError: Error
    {
        case shellCommandExecutionError(Error)
        case unableToDetectBranchName
    }
    
    func currentBranchName() throws -> String
    {
        do
        {
            if
                let currentBranchName = try shellOut(
                    to: #"git status | grep "On branch ""#
                    )
                    .split(separator: " ")
                    .last
            {
                return String(currentBranchName)
            }
            else
            {
                throw CurrentBranchDetectionError.unableToDetectBranchName
            }
        }
        catch
        {
            throw CurrentBranchDetectionError.shellCommandExecutionError(error)
        }
    }
}
