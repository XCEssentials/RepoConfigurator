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
extension Spec.CocoaPod
{
    struct SubSpec
    {
        public
        let name: String
        
        public
        let sourcesLocation: Path
        
        public
        let sourcesPattern: String
        
        public
        let resourcesLocation: Path
        
        public
        let resourcesPattern: String
        
        public
        let linterCfgLocation: Path
        
        public
        let tests: Bool
        
        public
        init(
            _ name: String = "Core",
            sourcesLocation: Path? = nil,
            sourcesPattern: String? = nil,
            resourcesLocation: Path? = nil,
            resourcesPattern: String? = nil,
            linterCfgLocation: Path? = nil,
            tests: Bool = false
            )
        {
            let name = (tests ? name + "Tests" : name)
            
            let sourcesLocation = sourcesLocation
                ?? (tests ? Spec.Locations.tests : Spec.Locations.sources) + name
            
            let sourcesPattern = sourcesPattern
                ?? (sourcesLocation + "**" + "*").rawValue
            
            let resourcesLocation = resourcesLocation
                ?? Spec.Locations.resources + name
            
            let resourcesPattern = resourcesPattern
                ?? (resourcesLocation + "**" + "*").rawValue
            
            let linterCfgLocation = linterCfgLocation
                ?? sourcesLocation
                
            //---
            
            self.name = name
            self.sourcesLocation = sourcesLocation
            self.sourcesPattern = sourcesPattern
            self.resourcesLocation = resourcesLocation
            self.resourcesPattern = resourcesPattern
            self.linterCfgLocation = linterCfgLocation
            self.tests = tests
        }
        
        public
        static
        func tests(
            _ name: String = "All",
            sourcesLocation: Path? = nil,
            sourcesPattern: String? = nil,
            resourcesLocation: Path? = nil,
            resourcesPattern: String? = nil,
            linterCfgLocation: Path? = nil
            ) -> SubSpec
        {
            return SubSpec(
                name,
                sourcesLocation: sourcesLocation,
                sourcesPattern: sourcesPattern,
                resourcesLocation: resourcesLocation,
                resourcesPattern: resourcesPattern,
                linterCfgLocation: linterCfgLocation,
                tests: true
            )
        }
    }
}

//---

public
extension Spec.CocoaPod.SubSpec
{
    enum ExtractionError: Error
    {
        case noModulesNorSubSpecsFound
    }
    
    static
    func extractAll(
        from tupleWithModulesOrSubSpecs: Any
        ) throws -> [Spec.CocoaPod.SubSpec]
    {
        if
            let modules = try? Spec
                .ArchitecturalLayer
                .extractAll(
                    from: tupleWithModulesOrSubSpecs
                )
        {
            return modules
                .flatMap{
                    [$0.main, $0.tests]
                }
        }
            
        //---
        
        let result = Mirror(
            reflecting: tupleWithModulesOrSubSpecs
            )
            .children
            .compactMap{
                $0.value as? Spec.CocoaPod.SubSpec
            }
        
        guard
            !result.isEmpty
        else
        {
            throw ExtractionError.noModulesNorSubSpecsFound
        }
        
        //---
        
        return result
    }
}
