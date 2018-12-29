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
protocol XcodeProjectTarget: RawRepresentable, CaseIterable
{
    var platform: OSIdentifier { get } // MSUT be listed in 'Spec.Product.deploymentTargets'
    var name: String { get }
    var productName: String { get }
    var bundleId: String { get }
    var provisioningProfiles: [Xcode.ProvisioningProfileKind : String] { get }
    var sourcesLocations: [Path] { get }
    var resourcesLocations: [Path] { get }
    var infoPlistLocation: Path { get }
    var packageType: Xcode.InfoPlist.PackageType { get }
}

//---

public
extension XcodeProjectTarget
    where
    RawValue == String
{
    var name: String
    {
        return platform.simplifiedTitle + title
    }
    
    var productName: String
    {
        return Spec.Product.name + "$(TARGET_NAME)"
    }
    
    var bundleId: String
    {
        guard
            let bundleIdPrefix = Spec.Company.bundleIdPrefix
        else
        {
            fatalError(
                "❌ Failed to construct '\(#function)' because 'bundleIdPrefix' is empty!"
            )
        }
        
        //---
        
        return bundleIdPrefix + "." + "$(PRODUCT_NAME)"
    }
    
    var provisioningProfiles: [Xcode.ProvisioningProfileKind : String]
    {
        return [:]
    }
    
    var sourcesLocations: [Path]
    {
        return [
            
            Spec.Locations.sources + name
        ]
    }
    
    var resourcesLocations: [Path]
    {
        return [
            
            Spec.Locations.resources + name
        ]
    }
    
    var infoPlistLocation: Path
    {
        return Spec.Locations.info + [name + ".plist"]
    }
}

//---

public
extension XcodeProjectTarget
{
    var deploymentTarget: DeploymentTarget
    {
        guard
            let minimumPlatformVersion = Spec.Product.deploymentTargets[platform]
        else
        {
            fatalError(
                "❌ Requested target for unsupported platform \(platform)!"
            )
        }
        
        //---
        
        return (platform, minimumPlatformVersion)
    }
}
