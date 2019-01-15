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
extension Spec
{
    struct CocoaPod
    {
        public
        let company: CocoaPods.Podspec.Company
        
        public
        let project: CocoaPods.Podspec.Project
        
        public
        let authors: [CocoaPods.Podspec.Author]
        
        public
        var currentVersion: VersionString
        
        public
        let xcodeArtifactsLocation: Path
        
        public
        var fullName: String
        {
            return company.prefix + project.name
        }
        
        public
        var podspecLocation: Path
        {
            return Utils
                .mutate([fullName]){
                    
                    $0.pathExtension = CocoaPods.Podspec.extension
                }
        }
        
        public
        var generatedXcodeProjectLocation: Path // WITHOUT extension!
        {
            return xcodeArtifactsLocation + fullName + "Pods"
        }
        
        public
        enum CompanyInfo
        {
            case from(Spec.Company)
            case use(CocoaPods.Podspec.Company)
        }
        
        public
        enum ProjectInfo
        {
            case from(Spec.Project)
            case use(CocoaPods.Podspec.Project)
        }
        
        public
        init(
            companyInfo: CompanyInfo,
            projectInfo: ProjectInfo,
            authors: [CocoaPods.Podspec.Author],
            currentVersion: VersionString? = nil,
            xcodeArtifactsLocation: Path? = nil
            ) throws
        {
            let podspecCompanyDescription: CocoaPods.Podspec.Company
            
            switch companyInfo
            {
            case .from(let company):
                podspecCompanyDescription = (
                    company.name,
                    company.identifier,
                    company.prefix
                )
                
            case .use(let value):
                podspecCompanyDescription = value
            }
            
            let podspecProjectDescription: CocoaPods.Podspec.Project
            
            switch projectInfo
            {
            case .from(let project):
                podspecProjectDescription = (
                    project.name,
                    project.summary
                )
                
            case .use(let value):
                podspecProjectDescription = value
            }
            
            let currentVersion = currentVersion
                ?? Defaults.initialVersionString
            
            let xcodeArtifactsLocation = xcodeArtifactsLocation
                ?? ["Xcode"]
            
            //---
            
            self.company = podspecCompanyDescription
            self.project = podspecProjectDescription
            self.authors = authors
            self.currentVersion = currentVersion
            self.xcodeArtifactsLocation = xcodeArtifactsLocation
        }
    }
}

// MARK: - Helpers

public
extension Spec.CocoaPod
{
    enum ReadCurrentVersionError: Error
    {
        case invalidAbsolutePodspecLocationPrefix
        case podspecNotFound(expectedPath: String)
    }
    
    mutating
    func readCurrentVersion(
        absolutePodspecLocationPrefix: Path? = nil,
        callFastlane method: GemCallMethod,
        shouldReport: Bool = true
        ) throws
    {
        let absolutePodspecLocationPrefix = try absolutePodspecLocationPrefix
            ?? Spec.LocalRepo.current().location
        
        try absolutePodspecLocationPrefix.isAbsolute
            ?! ReadCurrentVersionError.invalidAbsolutePodspecLocationPrefix
        
        try absolutePodspecLocationPrefix.exists
            ?! ReadCurrentVersionError.podspecNotFound(
                expectedPath: absolutePodspecLocationPrefix.rawValue
            )
        
        //---
        
        // NOTE: depends on https://fastlane.tools/
        
        // NOTE: depends on https://github.com/sindresorhus/find-versions-cli
        // run before first time usage:
        // try shellOut(to: "npm install --global find-versions-cli")
        
        self.currentVersion = try shellOut(
            to: """
            \(Fastlane.call(method)) run version_get_podspec path:"\((absolutePodspecLocationPrefix + podspecLocation).rawValue)" \
            | grep "Result:" \
            | find-versions
            """
        )
        
        //---
        
        if
            shouldReport
        {
            print("✅ Detected current pod version: \(currentVersion).")
        }
    }
}

// MARK: - SupSpecs

public
protocol PodSubSpecs: RawRepresentable, CaseIterable {}

public
extension PodSubSpecs
    where
    RawValue == String
{
    var sourcesLocation: Path
    {
        return Spec.Locations.sources + self.title
    }
    
    var sourcesPattern: String
    {
        return (
            sourcesLocation
            + "**"
            + "*.swift"
            )
            .rawValue
    }
    
    var linterCfgLocation: Path // for symlink !
    {
        return sourcesLocation + SwiftLint.relativeLocation
    }
}
