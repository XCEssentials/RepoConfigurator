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
import Files
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
        case multiplePodspecsFoundInFolder(folderPath: String)
        case noPodspecsFoundInFolder(folderPath: String)
        case notFound(filePath: String)
    }
    
    static
    func currentPodVersion(
        fromFolder targetFolder: Folder? = nil,
        callFastlane: Fastlane.CallMethod
        ) throws -> VersionString
    {
        let targetFolder = targetFolder ?? .current
        
        let podspecs = targetFolder
            .files
            .filter({ $0.extension == CocoaPods.Podspec.extension })
        
        //---
        
        if
            podspecs.count > 1
        {
            throw Error
                .multiplePodspecsFoundInFolder(folderPath: targetFolder.path)
        }
        
        guard
            let result = podspecs.first
        else
        {
            throw Error
                .noPodspecsFoundInFolder(folderPath: targetFolder.path)
        }
        
        //---
        
        return try currentVersion(
            fromFile: result,
            callFastlane: callFastlane
        )
    }
    
    static
    func currentPodVersion(
        fromPath podspec: Path,
        callFastlane: Fastlane.CallMethod
        ) throws -> VersionString
    {
        // ensure the file extension is set and correct
        
        var podspec = podspec
        podspec.pathExtension = CocoaPods.Podspec.extension
        
        //---
        
        return try currentVersion(
            fromFile: .init(path: podspec.rawValue),
            callFastlane: callFastlane
        )
    }
    
    private
    static
    func currentVersion(
        fromFile podspec: Files.File,
        callFastlane: Fastlane.CallMethod
        ) throws -> VersionString
    {
        // NOTE: depends on https://fastlane.tools/
        
        // NOTE: depends on https://github.com/sindresorhus/find-versions-cli
        // run before first time usage:
        // try shellOut(to: "npm install --global find-versions-cli")
        
        //---
        
        return try shellOut(
            to: """
            \(callFastlane.rawValue) run version_get_podspec path:"\(podspec.path)" \
            | grep "Result:" \
            | find-versions
            """
        )
    }
}