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

import Foundation
import XCTest

import FileKit
import SwiftHamcrest

@testable
import XCERepoConfigurator

//---

// let localRepo = try! Spec.LocalRepo.current()

fileprivate
let currentLocation: Path = [
    "SomeFolder",
    "XCEssentials",
    "Pipeline"
]

fileprivate
let localRepo = Spec.LocalRepo(
    location: currentLocation,
    context: currentLocation.parent.fileName
)

fileprivate
let remoteRepo = try! Spec.RemoteRepo(
    accountName: localRepo.context,
    name: localRepo.name
)

fileprivate
let company = try! Spec.Company(
    prefix: "XCE",
    name: localRepo.context,
    identifier: "com.\(localRepo.context)",
    developmentTeamId: "XYZ"
)

fileprivate
let project = try! Spec.Project(
    name: localRepo.name,
    summary: "Project summary",
    copyrightYear: 2019,
    deploymentTargets: [
        .iOS : "9.0",
        .watchOS : "3.0",
        .tvOS : "9.0",
        .macOS : "10.11"
    ]
)

// NOTE: declare as 'var' to call 'readCurrentVersion' method
fileprivate
let cocoaPod = try! Spec.CocoaPod(
    companyInfo: .from(company),
    productInfo: .from(project),
    authors: [
        (name: "Maxim Khatskevich", email: "maxim@khatskevi.ch")
    ]
)

enum SubSpecs
{
    static
    var core: Spec.CocoaPod.SubSpec
    {
        return .init(#function.capitalized)
    }
    
    static
    var operators: Spec.CocoaPod.SubSpec
    {
        return .init(#function.capitalized)
    }
    
    static
    var tests: Spec.CocoaPod.SubSpec
    {
        return .tests(#function.capitalized)
    }
}

//---

final
class FrameworkConfigExample: XCTestCase
{
    // MARK: Type level members
    
    static
    var allTests = [
        ("testLocalRepo", testLocalRepo),
        ("testRemoteRepo", testRemoteRepo),
        ("testCompany", testCompany),
        ("testProject", testProject),
        ("testCocoaPod", testCocoaPod),
        ("testCoreSubSpec", testCoreSubSpec),
        ("testTestsSubSpec", testTestsSubSpec)
    ]
}

//---

extension FrameworkConfigExample
{
    func testLocalRepo()
    {
        assertThat(localRepo.location == currentLocation)
        assertThat(localRepo.context == currentLocation.parent.fileName)
    }
    
    func testRemoteRepo()
    {
        assertThat(remoteRepo.serverAddress == "https://github.com")
        assertThat(remoteRepo.accountName == localRepo.context)
        assertThat(remoteRepo.name == localRepo.name)
    }
    
    func testCompany()
    {
        assertThat(company.prefix == "XCE")
        assertThat(company.name == localRepo.context)
        assertThat(company.identifier == "com.\(localRepo.context)")
        assertThat(company.developmentTeamId == "XYZ")
    }
    
    func testProject()
    {
        assertThat(project.name == localRepo.name)
        assertThat(project.summary == "Project summary")
        assertThat(project.copyrightYear == 2019)
        assertThat(project.deploymentTargets.count == 4)
        assertThat(project.deploymentTargets, hasKey(.iOS))
        assertThat(project.deploymentTargets, hasKey(.macOS))
        assertThat(project.location == [localRepo.name + "." + Xcode.Project.extension])
    }
    
    func testCocoaPod()
    {
        let cocoaPodFullName = company.prefix + project.name
        let podspec: Path = ["\(company.prefix)\(project.name).\(CocoaPods.Podspec.extension)"]
        let generatedXcodeProjectLocation: Path = ["Xcode"] + cocoaPodFullName + "Pods"
        
        assertThat(cocoaPod.company.name == company.name)
        assertThat(cocoaPod.company.identifier == company.identifier)
        assertThat(cocoaPod.company.prefix == company.prefix)
        assertThat(cocoaPod.product.name == project.name)
        assertThat(cocoaPod.product.summary == project.summary)
        assertThat(cocoaPod.authors.count == 1)
        assertThat(cocoaPod.authors[0].name == "Maxim Khatskevich")
        assertThat(cocoaPod.currentVersion == Defaults.initialVersionString)
        assertThat(cocoaPod.xcodeArtifactsLocation == ["Xcode"])
        assertThat(cocoaPod.fullName == cocoaPodFullName)
        assertThat(cocoaPod.podspecLocation == podspec)
        assertThat(cocoaPod.generatedXcodeProjectLocation == generatedXcodeProjectLocation)
    }
    
    func testCoreSubSpec()
    {
        let sources = Spec.Locations.sources
        let resources = Spec.Locations.resources
        let name = "Core"
        
        assertThat(SubSpecs.core.name == name)
        assertThat(SubSpecs.core.sourcesLocation == (sources + name))
        assertThat(SubSpecs.core.sourcesPattern == (sources + name + "**" + "*").rawValue)
        assertThat(SubSpecs.core.resourcesLocation == (resources + name))
        assertThat(SubSpecs.core.resourcesPattern == (resources + name + "**" + "*").rawValue)
        assertThat(SubSpecs.core.linterCfgLocation == (sources + name + SwiftLint.relativeLocation))
        assertThat(SubSpecs.core.tests == false)
    }
    
    func testTestsSubSpec()
    {
        let tests = Spec.Locations.tests
        let name = "Tests"
        
        assertThat(SubSpecs.tests.name == name)
        assertThat(SubSpecs.tests.sourcesLocation == (tests + name))
        assertThat(SubSpecs.tests.sourcesPattern == (tests + name + "**" + "*").rawValue)
        assertThat(SubSpecs.tests.tests == true)
    }
}
