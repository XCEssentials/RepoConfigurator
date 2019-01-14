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
struct RemoteRepo
{
    public
    let serverAddress: String
    
    public
    let accountName: String
    
    public
    let name: String
    
    public
    enum InitializationError: Swift.Error
    {
        case unableAutoDetectAccountName
        case unableAutoDetectRepoName
    }
    
    public
    init(
        serverAddress: String = "https://github.com",
        accountName: String? = nil,
        name: String? = nil
        ) throws
    {
        self.serverAddress = serverAddress
     
        let localRepo = try? Spec.LocalRepo.current()
        
        self.accountName = try accountName
            ?? localRepo?.context
            ?! InitializationError.unableAutoDetectAccountName
        
        self.name = try name
            ?? localRepo?.name
            ?! InitializationError.unableAutoDetectRepoName
    }
}

//---

public
extension RemoteRepo
{
    public
    enum Error: Swift.Error
    {
        case unableConstructFullRepoURL
    }
    
    func fullRepoAddress() throws -> URL
    {
        return try URL
            .init(
                string: [
                    serverAddress,
                    accountName,
                    name + ".git"
                    ]
                    .joined(separator: "/")
            )
            ?! Error.unableConstructFullRepoURL
    }
}
