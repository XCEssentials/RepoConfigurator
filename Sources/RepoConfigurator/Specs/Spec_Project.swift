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
extension Spec
{
    struct Project
    {
        public
        let name: String
        
        public
        let summary: String
        
        public
        let copyrightYear: UInt
        
        public
        let deploymentTargets: DeploymentTargets
        
        public
        let location: Path
        
        public
        enum Location
        {
            case auto
            case use(Path)
        }
        
        public
        enum InitializationError: Error
        {
            case nameAutoDetectionFailed
            case invalidLocation
            case nameAutoDetectionFailure
        }
        
        public
        init(
            name: String? = nil,
            summary: String,
            copyrightYear: UInt? = nil,
            deploymentTargets: DeploymentTargets,
            location: Location? = nil,
            shouldReport: Bool = false
            ) throws
        {
            let name = try name
                ?? LocalRepo.current().name
                ?! InitializationError.nameAutoDetectionFailed // non-nil, but zero-length
            
            let copyrightYear = copyrightYear
                ?? UInt(
                    Calendar
                        .current
                        .component(.year, from: Date())
                )
            
            let fileLocation: Path
            
            switch location ?? .auto
            {
            case .auto:
                fileLocation = Utils
                    .mutate([name]){
                        
                        $0.pathExtension = Xcode.Project.extension
                    }
                
            case .use(let location) where location.isRelative:
                fileLocation = Utils
                    .mutate(location){
                        
                        $0.pathExtension = Xcode.Project.extension // ensure right extension
                    }
                
            default:
                throw InitializationError.invalidLocation
            }
            
            //---
            
            self.name = name
            self.summary = summary
            self.copyrightYear = copyrightYear
            self.deploymentTargets = deploymentTargets
            self.location = fileLocation
            
            //---
            
            if
                shouldReport
            {
                report()
            }
        }
    }
}

// MARK: - Helpers

public
extension Spec.Project
{
    func report()
    {
        print("✅ Project name (without company prefix): \(name)")
    }
}
