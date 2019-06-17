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

import XCTest

import SwiftHamcrest
import Version

@testable
import XCERepoConfigurator

//---

final
class CocoaPodsTests: XCTestCase
{
    // MARK: Type level members
    
    static
    var allTests = [
        ("testGemNames", testGemNames),
        ("testPodspec", testPodspec)
    ]
    
}

//---

extension CocoaPodsTests
{
    func testGemNames()
    {
        assertThat(CocoaPods.gemName == "cocoapods")
        assertThat(CocoaPods.gemCallName == "pod")
    }
    
    func testPodspec()
    {
        let companyName = "XCEssentials"
        let projectName = "FrameworkTemplate"
        let repoDesc = "Repo description"
        
        let targetOutput = { """
            Pod::Spec.new do |s|

                s.name          = 'XCEFrameworkTemplate'
                s.summary       = 'Repo description'
                s.version       = '0.0.1'
                s.homepage      = 'https://XCEssentials.github.io/FrameworkTemplate'

                s.source        = { :git => 'https://github.com/XCEssentials/FrameworkTemplate.git', :tag => s.version }

                s.requires_arc  = true

                s.license       = { :type => 'MIT', :file => 'LICENSE' }

                s.authors = {
                    'Maxim Khatskevich' => 'maxim@khatskevi.ch'
                } # authors

                s.swift_version = '4.2'

                s.cocoapods_version = '>= 1.5.3'

                # === ios

                s.ios.deployment_target = '9.0'

                # === SUBSPECS ===

                s.subspec 'Core' do |ss|

                    ss.source_files = 'Sources/Core/**/*'

                end # subspec 'Core'

                s.subspec 'Operators' do |ss|

                    ss.dependency 'XCEFrameworkTemplate/Core'
                    ss.source_files = 'Sources/Operators/**/*'

                end # subspec 'Operators'

                s.test_spec 'AllTests' do |ss|

                    ss.requires_app_host = false
                    ss.dependency 'SwiftLint'
                    ss.source_files = 'Tests/AllTests/**/*'

                end # test_spec 'AllTests'

            end # spec s
            
            """
        }()
        .split(separator: "\n")
        
        //---
        
        let company = try! Spec.Company(
            prefix: "XCE",
            name: companyName,
            identifier: "com.\(companyName)"
        )

        let project = try! Spec.Project(
            name: projectName,
            summary: repoDesc,
            copyrightYear: 2019,
            deploymentTargets: [
                .iOS : "9.0"
            ],
            location: .use([""]) // doesn't matter for this test
        )

        let cocoaPod = try! Spec.CocoaPod(
            companyInfo: .from(company),
            productInfo: .from(project),
            authors: [
                ("Maxim Khatskevich", "maxim@khatskevi.ch")
            ]
        )

        let license: CocoaPods.Podspec.License = (
            License.MIT.licenseType,
            License.MIT.relativeLocation
        )

        let subSpecs = (
            core: Spec.CocoaPod.SubSpec("Core"),
            operators: Spec.CocoaPod.SubSpec("Operators"),
            tests: Spec.CocoaPod.SubSpec.tests()
        )

        //---
        
        let result = try! CocoaPods
            .Podspec
            .withSubSpecs(
                project: project,
                company: cocoaPod.company,
                version: cocoaPod.currentVersion,
                license: license,
                authors: cocoaPod.authors,
                swiftVersion: Spec.BuildSettings.swiftVersion.value,
                globalSettings: {
                    
                    globalContext in
                    
                    //declare support for all defined deployment targets
                    
                    project
                        .deploymentTargets
                        .forEach{ globalContext.settings(for: $0) }
                },
                subSpecs: {

                    let core = subSpecs.core
                    
                    $0.subSpec(core.name){

                        $0.settings(
                            .sourceFiles(core.sourcesPattern)
                        )
                    }
                    
                    let operators = subSpecs.operators

                    $0.subSpec(operators.name){
                        
                        $0.settings(
                            .dependency("\(cocoaPod.product.name)/\(core.name)"),
                            .sourceFiles(operators.sourcesPattern)
                        )
                    }
                },
                testSubSpecs: {
                    
                    let tests = subSpecs.tests

                    $0.testSubSpec(tests.name){

                        $0.settings(
                            .noPrefix("requires_app_host = false"),
                            .dependency("SwiftLint"), // we will be running linting from unit tests!
                            .sourceFiles(tests.sourcesPattern)
                        )
                    }
                }
            )
            .prepare(for: cocoaPod)
            .content
            .split(separator: "\n")
        
        //---
        
        for (i, expected) in targetOutput.enumerated()
        {
            assertThat(expected == result[i])
        }
    }
    
    func testVersions()
    {
        let rawVer = "app.version = '1.0.1'"
        assertThat(try Spec.CocoaPod.extracVersionString(from: rawVer), equalTo("1.0.1"))
    }
}
