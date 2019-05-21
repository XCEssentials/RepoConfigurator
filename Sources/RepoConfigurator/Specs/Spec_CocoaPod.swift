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
import Version

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
        case podspecNotFound(expectedPath: String)
        case unableToDetectVersionString(rawSpecContent: String)
    }
    
    mutating
    func readCurrentVersion(
        specLocation: Path? = nil,
        shouldReport: Bool = true
        ) throws
    {
        let specLocation = specLocation ?? self.podspecLocation
        
        let targetLocation = try (
            specLocation.isAbsolute ?
            specLocation :
            Spec.LocalRepo.current().location + specLocation
        )
        
        try targetLocation.exists
            ?! ReadCurrentVersionError.podspecNotFound(
                expectedPath: targetLocation.rawValue
            )
        
        let specContent = try String(
            contentsOfFile: targetLocation.rawValue
        )
        
        let result = try type(of: self).extracVersionString(
            from: specContent
        )
        
        //---
        
        self.currentVersion = result
        
        //---
        
        if
            shouldReport
        {
            print("✅ Detected current pod version: \(currentVersion).")
        }
    }
}

//internal
extension Spec.CocoaPod
{
    static
    func extracVersionString(
        from rawSpecContent: String
        ) throws -> VersionString
    {
        let rawVersionString = try rawSpecContent
            .components(
                separatedBy: .newlines
            )
            .filter{
                $0.lowercased().contains("version")
            }
            .first?
            .components(
                separatedBy: .whitespaces
            )
            .last?
            .trimmingCharacters(
                in: .punctuationCharacters
            )
            ?! ReadCurrentVersionError.unableToDetectVersionString(
                rawSpecContent: rawSpecContent
            )
        
        let result = try Version(
            rawVersionString
            )
            ?! ReadCurrentVersionError.unableToDetectVersionString(
                rawSpecContent: rawSpecContent
            )
        
        return result.description
    }
}
