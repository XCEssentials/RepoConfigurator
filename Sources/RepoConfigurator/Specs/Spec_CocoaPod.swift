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
        let product: CocoaPods.Podspec.Product
        
        public
        let authors: [CocoaPods.Podspec.Author]
        
        public
        var currentVersion: VersionString
        
        public
        let xcodeArtifactsLocation: Path
        
        public
        var podspecLocation: Path
        {
            return Utils
                .mutate([product.name]){
                    
                    $0.pathExtension = CocoaPods.Podspec.extension
                }
        }
        
        public
        var generatedXcodeProjectLocation: Path
        {
            return xcodeArtifactsLocation + product.name + "Pods.\(Xcode.Project.extension)"
        }
        
        public
        enum CompanyInfo
        {
            case from(Spec.Company)
            case use(CocoaPods.Podspec.Company)
        }
        
        public
        enum ProductInfo
        {
            case from(Spec.Project)
            case use(CocoaPods.Podspec.Product)
        }
        
        public
        init(
            companyInfo: CompanyInfo,
            productInfo: ProductInfo,
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
            
            let podspecProductDescription: CocoaPods.Podspec.Product
            
            switch productInfo
            {
            case .from(let project):
                podspecProductDescription = (
                    podspecCompanyDescription.prefix + project.name,
                    project.summary
                )
                
            case .use(let value):
                podspecProductDescription = value
            }
            
            let currentVersion = currentVersion
                ?? Defaults.initialVersionString
            
            let xcodeArtifactsLocation = xcodeArtifactsLocation
                ?? ["Xcode"]
            
            //---
            
            self.company = podspecCompanyDescription
            self.product = podspecProductDescription
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
    func report()
    {
        print("✅ CocoaPod authors: \(authors).")
        print("✅ CocoaPod current version: \(currentVersion).")
        print("✅ CocoaPod xcodeArtifactsLocation: \(xcodeArtifactsLocation.rawValue).")
    }
    
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
        
        let targetPodspecLocation = absolutePodspecLocationPrefix + podspecLocation
        
        try targetPodspecLocation.exists
            ?! ReadCurrentVersionError.podspecNotFound(
                expectedPath: targetPodspecLocation.rawValue
            )
        
        //---
        
        // NOTE: depends on https://fastlane.tools/
        
        // NOTE: depends on https://github.com/sindresorhus/find-versions-cli
        // run before first time usage:
        // try shellOut(to: "npm install --global find-versions-cli")
        
        let result = try shellOut(
            to: """
            \(Fastlane.call(method)) run version_get_podspec path:"\(targetPodspecLocation.rawValue)" \
            | grep "Result:" \
            | find-versions
            """
        )
        
        //--- undefined
        
        if
            result != "undefined"
            && !result.isEmpty
        {
            self.currentVersion = result
            
            //---
            
            if
                shouldReport
            {
                print("✅ Detected current pod version: \(currentVersion).")
            }
        }
    }
}
