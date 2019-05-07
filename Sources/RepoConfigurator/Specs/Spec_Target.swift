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

//---

public
extension Spec
{
    struct Target
    {
        public
        let name: String
        
        public
        let deploymentTarget: DeploymentTarget
        
        public
        let productName: String
        
        public
        let bundleId: String
        
        public
        let provisioningProfiles: [Xcode.ProvisioningProfileKind : String]
        
        public
        let infoPlistLocation: Path
        
        public
        let sourcesLocation: Path
        
        public
        let resourcesLocation: Path
        
        public
        let linterCfgLocation: Path
        
        public
        let packageType: Xcode.InfoPlist.PackageType
        
        public
        enum ProductInfo
        {
            case fromProject
            
            case use(
                productName: String
            )
        }
        
        public
        enum BundleIdInfo
        {
            case autoWithCompany(
                Spec.Company
            )
            
            case autoWithCompanyId(
                String
            )
            
            case use(
                String
            )
        }
        
        public
        enum InitializationError: Error
        {
            case unsupportedDeploymentTarget
        }
        
        public
        init(
            _ name: String,
            project: Spec.Project,
            platform: OSIdentifier,
            productInfo: ProductInfo? = nil,
            bundleIdInfo: BundleIdInfo,
            provisioningProfiles: [Xcode.ProvisioningProfileKind : String],
            infoPlistLocation: Path? = nil,
            sourcesLocation: Path? = nil,
            resourcesLocation: Path? = nil,
            linterCfgLocation: Path? = nil,
            packageType: Xcode.InfoPlist.PackageType
            ) throws
        {
            let deploymentTarget = try project.deploymentTargets.asPair(platform)
                ?! InitializationError.unsupportedDeploymentTarget
            
            let productName: String
            
            switch productInfo ?? .fromProject
            {
            case .fromProject:
                productName = project.name + name
                
            case .use(let value):
                productName = value + name
            }
            
            let bundleId: String
            
            switch bundleIdInfo
            {
            case .autoWithCompany(let company):
                bundleId = company.identifier + "." + productName
                
            case .autoWithCompanyId(let companyId):
                bundleId = companyId + "." + productName
                
            case .use(let value):
                bundleId = value
            }
            
            let infoPlistLocation = infoPlistLocation
                ?? (Spec.Locations.info + [name + "." + Xcode.InfoPlist.extension])
            
            let sourcesLocation = sourcesLocation
                ?? (
                    (packageType == .tests ? Spec.Locations.tests : Spec.Locations.sources)
                        + name
                )
            
            let resourcesLocation = resourcesLocation
                ?? (Spec.Locations.resources + name)
            
            let linterCfgLocation = linterCfgLocation
                ?? sourcesLocation
            
            //---
            
            self.name = name
            self.deploymentTarget = deploymentTarget
            self.productName = productName
            self.bundleId = bundleId
            self.provisioningProfiles = provisioningProfiles
            self.infoPlistLocation = infoPlistLocation
            self.sourcesLocation = sourcesLocation
            self.resourcesLocation = resourcesLocation
            self.linterCfgLocation = linterCfgLocation
            self.packageType = packageType
        }
    }
}
