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
protocol ArchitecturalLayer
{
    static
    var deploymentTargets: [OSIdentifier: VersionString] { get }
    
    static
    var name: String { get }
    
    static
    var moduleName: String { get }
    
    static
    var summary: String { get }
    
    static
    var podspecLocation: Path { get }
}

public
extension ArchitecturalLayer
{
    static
    var name: String
    {
        return String(describing: self)
    }
    
    static
    var moduleName: String
    {
        return Spec.Project.name + name
    }
    
    static
    var podspecLocation: Path
    {
        return [moduleName + "." + CocoaPods.Podspec.extension]
    }
}

public
extension ArchitecturalLayer
{
    static
    var isCrossPlatform: Bool
    {
        return deploymentTargets.count > 1
    }
    
    static
    var product: CocoaPods.Podspec.Project
    {
        return (
            moduleName,
            summary
        )
    }
}

//---

public
protocol ArchitecturalLayerSubspec
{
    associatedtype Layer: ArchitecturalLayer
    
    static
    var name: String { get }
    
    static
    var sourcesLocation: Path { get }
    
    static
    var resourcesLocation: Path { get }
}

public
extension ArchitecturalLayerSubspec
{
    static
    var name: String
    {
        return String(describing: self)
    }
    
    static
    var sourcesLocation: Path
    {
        // usually expect only one "Core" subspec,
        // so the sources folder is named after the layer itself
        return Spec.Locations.sources + Layer.name
    }
    
    static
    var resourcesLocation: Path
    {
        // usually expect only one "Core" subspec,
        // so the resources folder is named after the layer itself
        return Spec.Locations.resources + Layer.name
    }
}

public
extension ArchitecturalLayerSubspec
{
    static
    var sourcesPattern: String
    {
        return (
            sourcesLocation
                + "**"
                + "*"
            )
            .rawValue
    }
    
    static
    var resourcesPattern: String
    {
        return (
            resourcesLocation
                + "**"
                + "*"
            )
            .rawValue
    }
}

//---

public
protocol ArchitecturalLayerTestSubspec: ArchitecturalLayerSubspec {}

public
extension ArchitecturalLayerTestSubspec
{
    static
    var sourcesLocation: Path
    {
        return Spec.Locations.sources + (Layer.name + name)
    }

    static
    var resourcesLocation: Path
    {
        return Spec.Locations.resources + (Layer.name + name)
    }
}
