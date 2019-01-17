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
    "Dev",
    "MyCompany",
    "HelloApp"
]

fileprivate
let localRepo = Spec.LocalRepo(
    location: currentLocation,
    context: currentLocation.parent.fileName
)

fileprivate
let project = try! Spec.Project(
    name: localRepo.name,
    summary: "Project summary",
    copyrightYear: 2019,
    deploymentTargets: [
        .iOS : "9.0"
    ]
)

fileprivate
enum Modules
{
    static
    var MobileViews: Spec.ArchitecturalLayer
    {
        return try! .init(
            project: project,
            name: #function,
            summary: "[View] level types according to MVVMSE.",
            deploymentTargets: project
                .deploymentTargets
                .filter{ $0.key == .iOS }
        )
    }
    
    static
    var ViewModels: Spec.ArchitecturalLayer
    {
        return try! .init(
            project: project,
            name: #function,
            summary: "[ViewModel] level types according to MVVMSE."
        )
    }
    
    static
    var Models: Spec.ArchitecturalLayer
    {
        return try! .init(
            project: project,
            name: #function,
            summary: "[Model] level types according to MVVMSE."
        )
    }
    
    static
    var Services: Spec.ArchitecturalLayer
    {
        return try! .init(
            project: project,
            name: #function,
            summary: "[Service] level types according to MVVMSE."
        )
    }
}

//---

final
class AppConfigTests: XCTestCase
{
    // MARK: Type level members
    
    static
    var allTests = [
        ("testArchitecturalLayers", testArchitecturalLayers)
    ]
}

//---

extension AppConfigTests
{
    func testArchitecturalLayers()
    {
        let moduleName = "MobileViews"
        let productName = "\(project.name)\(moduleName)"
        let moduleSummary = "[View] level types according to MVVMSE."
        let podspecLocation: Path = [productName + "." + CocoaPods.Podspec.extension]
        
        let subSpecNames = (
            core: moduleName,
            tests: moduleName + "Tests"
        )
        
        assertThat(Modules.MobileViews.name == moduleName)
        assertThat(Modules.MobileViews.product.name == productName)
        assertThat(Modules.MobileViews.product.summary == moduleSummary)
        assertThat(Modules.MobileViews.deploymentTargets.count == 1)
        assertThat(Modules.MobileViews.deploymentTargets, hasKey(.iOS))
        assertThat(Modules.MobileViews.isCrossPlatform == false)
        assertThat(Modules.MobileViews.podspecLocation == podspecLocation)
        assertThat(Modules.MobileViews.main.name == subSpecNames.core)
        assertThat(Modules.MobileViews.tests.name == subSpecNames.tests)
    }
}

