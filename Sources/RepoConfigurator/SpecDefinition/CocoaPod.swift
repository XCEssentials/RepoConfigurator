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
    enum CocoaPod {}
}

// MARK: - Configurable parameters

public
extension Spec.CocoaPod
{
    static
    var namePrefix: String?
    
    static
    var name: String = Spec.Product.name
    
    static
    var summary: String?
    
    static
    var authors: [CocoaPods.Podspec.Author] = []
    
    static
    var currentVersion: VersionString = Defaults.initialVersionString
    
    static
    var xcodeArtifactsLocation: Path = ["Xcode"]
}

// MARK: - Derived parameters

public
extension Spec.CocoaPod
{
    static
    var fullName: String
    {
        return (namePrefix ?? "") + name
    }
    
    static
    func company(
        file: StaticString = #file,
        line: UInt = #line
        ) -> CocoaPods.Podspec.Company
    {
        return (
            name: Spec.Company.name,
            identifier: Spec.Company.bundleIdPrefix.require(file: file, line: line),
            prefix: namePrefix.require(file: file, line: line)
        )
    }
    
    static
    func product(
        file: StaticString = #file,
        line: UInt = #line
        ) -> CocoaPods.Podspec.Product
    {
        return (
            name: name,
            summary: summary.require(file: file, line: line)
        )
    }
    
    static
    var podspecLocation: Path
    {
        return [fullName + "." + CocoaPods.Podspec.extension]
    }
    
    static
    var generatedXcodeProjectLocation: Path // WITHOUT extension!
    {
        return xcodeArtifactsLocation + fullName + "Pods"
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
