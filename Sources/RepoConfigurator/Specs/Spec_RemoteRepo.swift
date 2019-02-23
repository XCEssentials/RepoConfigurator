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
extension Spec
{
    struct RemoteRepo
    {
        public
        let serverAddress: String
        
        public
        let accountName: String
        
        public
        let name: String
        
        public
        let fullRepoAddress: URL
        
        public
        enum InitializationError: Swift.Error
        {
            case accountNameAutoDetectionFailed
            case repoNameAutoDetectionFailed
            case fullRepoURLConstructionFailed
        }
        
        public
        init(
            serverAddress: String = "https://github.com",
            accountName: String? = nil,
            name: String? = nil,
            shouldReport: Bool = false
            ) throws
        {
            let localRepo: () -> Spec.LocalRepo? = {
                
                try? Spec.LocalRepo.current(shouldReport: shouldReport)
            }
            
            let accountName = try accountName
                ?? localRepo()?.context
                ?! InitializationError.accountNameAutoDetectionFailed
            
            let name = try name
                ?? localRepo()?.name
                ?! InitializationError.repoNameAutoDetectionFailed
            
            let fullRepoAddressStr = [
                serverAddress,
                accountName,
                name + ".git"
                ]
                .joined(separator: "/")
            
            let fullRepoAddress = try URL(string: fullRepoAddressStr)
                ?! InitializationError.fullRepoURLConstructionFailed
            
            //---
            
            self.serverAddress = serverAddress
            self.accountName = accountName
            self.name = name
            self.fullRepoAddress = fullRepoAddress
            
            //---
            
            if
                shouldReport
            {
                self.report()
            }
        }
    }
}

//---

public
extension Spec.RemoteRepo
{
    func report()
    {
        print("✅ Remote repo: \(fullRepoAddress.absoluteString)")
    }
}
