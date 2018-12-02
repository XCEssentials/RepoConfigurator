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
import ShellOut

//---

public
extension Read
{
    public
    enum CocoaPods {}
}

//---

public
extension Read.CocoaPods
{
    enum Error: Swift.Error
    {
        case multiplePodspecsFoundInFolder(path: String)
        case noPodspecsFoundInFolder(path: String)
        case invalidPodspec(path: String)
    }
    
    static
    func currentVersion(
        fromLocation location: Path = Spec.LocalRepo.location,
        callFastlane method: GemCallMethod
        ) throws -> VersionString
    {
        let podspecs = location.find(
            searchDepth: 0,
            condition: { $0.pathExtension == CocoaPods.Podspec.extension }
        )
        
        //---
        
        if
            podspecs.count > 1
        {
            throw Error.multiplePodspecsFoundInFolder(path: location.rawValue)
        }
        
        guard
            let podspecFile = podspecs.first
        else
        {
            throw Error.noPodspecsFoundInFolder(path: location.rawValue)
        }
    
        guard
            (podspecFile.fileName == Spec.CocoaPod.fullName ) &&
            (podspecFile.pathExtension == CocoaPods.Podspec.extension )
        else
        {
            throw Error.invalidPodspec(path: podspecFile.rawValue)
        }
        
        //---
        
        // NOTE: depends on https://fastlane.tools/
        
        // NOTE: depends on https://github.com/sindresorhus/find-versions-cli
        // run before first time usage:
        // try shellOut(to: "npm install --global find-versions-cli")
        
        return try shellOut(
            to: """
            \(Fastlane.call(method)) run version_get_podspec path:"\(podspecFile.rawValue)" \
            | grep "Result:" \
            | find-versions
            """
        )
    }
}
