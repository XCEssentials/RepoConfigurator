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
    struct Module
    {
        public
        let product: CocoaPods.Podspec.Product
        
        public
        let deploymentTargets: DeploymentTargets
        
        public
        var isCrossPlatform: Bool
        {
            return deploymentTargets.count > 1
        }
        
        public
        let podspecLocation: Path
        
        public
        let main: Spec.CocoaPod.SubSpec
        
        public
        let tests: Spec.CocoaPod.SubSpec
        
        public
        enum InitializationError: Error
        {
            case deploymentTargetsAutoDetectionFailed
        }
        
        public
        init(
            project: Spec.Project,
            name: String,
            summary: String,
            deploymentTargets: DeploymentTargets? = nil,
            podspecLocation: Path? = nil
            ) throws
        {
            let product: CocoaPods.Podspec.Product = (
                    project.name + name, // no need company prefix, cause its for apps
                    summary
                )
            
            let deploymentTargets = try deploymentTargets
                ?? project.deploymentTargets
                ?! InitializationError.deploymentTargetsAutoDetectionFailed
            
            let podspecLocation = Utils
                .mutate(podspecLocation ?? [product.name]){
                    
                    $0.pathExtension = CocoaPods.Podspec.extension // ensure right extension
                }
            
            //---
            
            self.product = product
            self.deploymentTargets = deploymentTargets
            self.podspecLocation = podspecLocation
            
            // 'main' subspec basically represents the module itself,
            // so we jsut repeat product/module name here
            self.main = .init(
                name
            )
            
            // 'tests' subspec only makes sense in context the module itself,
            // so it's fine to have it named just "Tests"
            self.tests = .tests(
                name // NOTE: will be extended with "Tests"
            )
        }
    }
}

//---

public
extension Spec.Module
{
    enum ExtractionError: Error
    {
        case noModulesFound
    }
    
    static
    func extractAll(
        from tupleWithModules: Any
        ) throws -> [Spec.Module]
    {
        let result = Mirror(
            reflecting: tupleWithModules
            )
            .children
            .compactMap{
                $0.value as? Spec.Module
            }
        
        //---
        
        guard
            !result.isEmpty
        else
        {
            throw ExtractionError.noModulesFound
        }
        
        //---
        
        return result
    }
}
