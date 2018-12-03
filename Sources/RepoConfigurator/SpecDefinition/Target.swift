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
        let layer: Layer
        
        public
        let kind: Kind
        
        public
        let deploymentTarget: DeploymentTarget
        
        // MARK: Initializers
        
        public
        init(
            _ layer: Target.Layer,
            _ kind: Target.Kind,
            _ platform: OSIdentifier,
            file: StaticString = #file,
            line: UInt = #line
            )
        {
            guard
                let minimumPlatformVersion = Spec.Product.deploymentTargets[platform]
            else
            {
                fatalError(
                    "❌ Requested target for unsupported platform \(platform)!",
                    file: file,
                    line: line
                )
            }
            
            //---
            
            self.layer = layer
            self.kind = kind
            self.deploymentTarget = (platform, minimumPlatformVersion)
        }
    }
}

// MARK: - Nested types

public
extension Spec.Target
{
    enum Layer: String, CaseIterable
    {
        case app
        case models
        case services
        
        public
        var isExecutable: Bool
        {
            return self == .app
        }
    }
    
    enum Kind: String, CaseIterable
    {
        case main = ""
        case tst = "Tests"
    }
    
    enum ProvisioningProfileKind: String, CaseIterable
    {
        case dev
        case adHoc
        case appStore
        
        // more TBA...
    }
}

// MARK: - Other parameters

public
extension Spec.Target
{
    var name: String
    {
        //remember - cross-platform fwks!
        
        return (layer.isExecutable ? deploymentTarget.platform.simplifiedTitle : "")
            + layer.title
            + kind.rawValue
    }
    
    var productName: String
    {
        return Spec.Product.name + name
    }
    
    var bundleId: String
    {
        return Spec.Company.bundleIdPrefix.require() + "." + productName
    }
    
    func provisioningProfile(
        _ kind: ProvisioningProfileKind,
        file: StaticString = #file,
        line: UInt = #line
        ) -> String
    {
        guard
            layer.isExecutable
        else
        {
            fatalError(
                "❌ Requested provisioning profile for a non-executable target \(name)!",
                file: file,
                line: line
            )
        }
        
        //---
        
        return productName + "-" + kind.title
    }
    
    var sourcesLocations: [Path]
    {
        return [
            
            Spec.Locations.sources + [name]
        ]
    }
    
    var infoPlistLocation: Path
    {
        return Spec.Locations.info + [name + ".plist"]
    }
}

