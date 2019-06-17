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

import PathKit
import SwiftHamcrest

// @testable
import XCERepoConfigurator

//---

final
class FastlaneTests: XCTestCase
{
    // MARK: Type level members

    static
    var allTests = [
        ("testGemName", testGemName),
        ("testFileNames", testFileNames),
        ("testDefaultHeader", testDefaultHeader),
        ("testLibraryBeforeReleaseLane", testLibraryBeforeReleaseLane),
        ("testLibraryGenerateProjectViaCPLane", testLibraryGenerateProjectViaCPLane),
        ("testLibraryGenerateProjectViaSwiftPMLane", testLibraryGenerateProjectViaSwiftPMLane),
        ("testAppBeforeReleaseLane", testAppBeforeReleaseLane)
        ]

}

//---

extension FastlaneTests
{
    func testGemName()
    {
        XCTAssertEqual(Fastlane.gemName, "fastlane")
    }
    
    func testFileNames()
    {
        let expectedRelativeLocation: Path = Fastlane.Fastfile.relativeLocation
        let expectedAbsolutePrefixLocation: Path = Some.path + expectedRelativeLocation
        
        assertThat(
            Fastlane
                .Fastfile
                .ForApp
                .relativeLocation
                == expectedRelativeLocation
        )
        
        assertThat(
            Fastlane
                .Fastfile
                .ForLibrary
                .relativeLocation
                == expectedRelativeLocation
        )
        
        assertThat(
            try! Fastlane
                .Fastfile()
                .prepare(
                    at: Some.path
                )
                .location
                == expectedAbsolutePrefixLocation
        )

        assertThat(
            try! Fastlane
                .Fastfile
                .ForApp()
                .prepare(
                    at: Some.path
                )
                .location
                == expectedAbsolutePrefixLocation
        )

        assertThat(
            try! Fastlane
                .Fastfile
                .ForLibrary()
                .prepare(
                    at: Some.path
                )
                .location
            == expectedAbsolutePrefixLocation
        )
    }
    
    func testDefaultHeader()
    {
        let targetOutput = { """
            # Customise this file, documentation can be found here:
            # https://github.com/KrauseFx/fastlane/tree/master/docs
            # All available actions: https://github.com/KrauseFx/fastlane/blob/master/docs/Actions.md
            # can also be listed using the `fastlane actions` command

            # Change the syntax highlighting to Ruby
            # All lines starting with a # are ignored when running `fastlane`

            # More information about multiple platforms in fastlane: https://github.com/KrauseFx/fastlane/blob/master/docs/Platforms.md
            # All available actions: https://github.com/KrauseFx/fastlane/blob/master/docs/Actions.md

            # By default, fastlane will send which actions are used
            # No personal data is shared, more information on https://github.com/fastlane/enhancer
            # Uncomment the following line to opt out
            # opt_out_usage

            # If you want to automatically update fastlane if a new version is available:
            # update_fastlane

            # This is the minimum version number required.
            # Update this, if you use features of a newer version
            fastlane_version '2.100.0'
            
            """
        }()
        .split(separator: "\n")
        
        //---
        
        let result = try! Fastlane
            .Fastfile()
            .defaultHeader()
            .prepare(
                at: Some.path
            )
            .content
            .split(separator: "\n")
        
        //---
        
        for (i, expected) in targetOutput.enumerated()
        {
            assertThat(expected == result[i])
        }
    }
    
    func testLibraryBeforeReleaseLane()
    {
        let cocoaPodsModuleName = "XCEPipeline.podspec"
        
        let targetOutput = { """
            
            lane :beforeRelease do

                ensure_git_branch(
                    branch: '(release/*|hotfix/*)'
                )

                ensure_git_status_clean

                # ===

                pod_lib_lint(
                    allow_warnings: true,
                    quick: true
                )

                # === Remember current version number

                versionNumber = version_get_podspec(
                    path: '\(cocoaPodsModuleName)'
                )

                puts 'Current VERSION number: ' + versionNumber

                # === Infer new version number

                newVersionNumber = git_branch.split('/').last

                puts 'New VERSION number: ' + newVersionNumber

                # === Bump version number & commit changes

                version_bump_podspec(
                    path: '\(cocoaPodsModuleName)',
                    version_number: newVersionNumber
                )

                git_commit(
                    path: '\(cocoaPodsModuleName)',
                    message: 'Version Bump to ' + newVersionNumber + ' in Podspec file'
                )

            end # lane :beforeRelease
            """
        }()
        .split(separator: "\n")
        
        //---
        
        let result = try! Fastlane
            .Fastfile
            .ForLibrary()
            .beforeRelease(
                podspecLocation: .use([cocoaPodsModuleName])
            )
            .prepare(
                at: Some.path
            )
            .content
            .split(separator: "\n")
        
        //---
        
        for (i, expected) in targetOutput.enumerated()
        {
            assertThat(expected == result[i])
        }
    }
    
    func testLibraryGenerateProjectViaCPLane()
    {
        let targetOutput = { """
            
            lane :generateProjectViaCP do
            
                # === Regenerate project
            
                # default initial location for any command
                # is inside 'Fastlane' folder
            
                sh 'cd ./.. && rm -rf "Xcode" && pod gen --gen-directory="Xcode"'
            
            end # lane :generateProjectViaCP
            """
        }()
        .split(separator: "\n")
        
        //---
        
        let result = try! Fastlane
            .Fastfile
            .ForLibrary()
            .generateProjectViaCP(
                callCocoaPods: .directly
            )
            .prepare(
                at: Some.path
            )
            .content
            .split(separator: "\n")
        
        //---
        
        for (i, expected) in targetOutput.enumerated()
        {
            assertThat(expected == result[i])
        }
    }
    
    func testLibraryGenerateProjectViaSwiftPMLane()
    {
        let scriptName = "SwiftLint"
        
        let targetOutput = { """
            
            lane :generateProjectViaSwiftPM do
            
                # === Regenerate project
            
                # default initial location for any command
                # is inside 'Fastlane' folder
            
                sh 'cd ./.. && rm -rf ".build" && rm -rf "XCEMyFwk.xcodeproj" && swift package generate-xcodeproj'

                # === Build Phase Script - \(scriptName) | 'XCEMyFwk' | ../XCEMyFwk.xcodeproj

                begin

                    project = Xcodeproj::Project.open("../XCEMyFwk.xcodeproj")

                rescue => ex

                    # https://github.com/fastlane/fastlane/issues/7944#issuecomment-274232674
                    UI.error ex
                    UI.error("Failed to add Build Phase Script - \(scriptName) | 'XCEMyFwk' | ../XCEMyFwk.xcodeproj")

                end

                project
                    .targets
                    .select{ |t| ['XCEMyFwk'].include?(t.name) }
                    .each{ |t|

                        thePhase = t.shell_script_build_phases.find { |s| s.name == "\(scriptName)" }

                        unless thePhase.nil?
                            t.build_phases.delete(thePhase)
                        end

                        thePhase = t.new_shell_script_build_phase("\(scriptName)")
                        thePhase.shell_script = '"Pods/SwiftLint/swiftlint" '
                        # thePhase.run_only_for_deployment_postprocessing = ...

                        t.build_phases.unshift(t.build_phases.delete(thePhase)) # move to top

                    }

                project.save()

                UI.success("Added Build Phase Script - \(scriptName) | 'XCEMyFwk' | ../XCEMyFwk.xcodeproj")
            
            end # lane :generateProjectViaSwiftPM
            """
        }()
        .split(separator: "\n")
        
        let company = try! Spec.Company(
            prefix: "XCE",
            name: ""
        )
        
        let project = try! Spec.Project(
            name: "MyFwk",
            summary: "",
            deploymentTargets: [:]
        )
        
        let library = try! Spec.CocoaPod(
            companyInfo: .from(company),
            productInfo: .from(project),
            authors: []
        )
        
        //---
        
        let result = try! Fastlane
            .Fastfile
            .ForLibrary()
            .generateProjectViaSwiftPM(
                for: library,
                scriptBuildPhases: {
                    
                    try! $0.swiftLint(
                        project: [library.product.name],
                        targetNames: [library.product.name]
                    )
                }
            )
            .prepare(
                at: Some.path
            )
            .content
            .split(separator: "\n")
        
        //---
        
        for (i, expected) in targetOutput.enumerated()
        {
            assertThat(expected == result[i])
        }
    }
    
    func testAppBeforeReleaseLane()
    {
        let targetOutput = { """
            
            lane :beforeRelease do

                ensure_git_branch(
                    branch: '(release/*|hotfix/*)'
                )

                ensure_git_status_clean

                # === Read current version number

                versionNumber = version_get_podspec(
                    path: 'Project.spec'
                )

                puts 'Current VERSION number: ' + versionNumber

                # === Infer new version number

                defaultNewVersion = git_branch.split('/').last

                # === Define new version & build number

                useInferredNEWVersionNumber = prompt(
                    text: 'Proceed with inferred NEW version number (' + defaultNewVersion + ')?',
                    boolean: true
                )

                if useInferredNEWVersionNumber

                    newVersionNumber = defaultNewVersion

                else

                    newVersionNumber = prompt(
                        text: 'New VERSION number:'
                    )

                end

                newBuildNumber = number_of_commits.to_s

                # === Apply NEW version & build number

                increment_version_number(
                    xcodeproj: 'AppTemplate.xcodeproj',
                    version_number: newVersionNumber
                )

                increment_build_number(
                    xcodeproj: 'AppTemplate.xcodeproj',
                    build_number: newBuildNumber
                )

                version_bump_podspec(
                    path: 'Project.spec',
                    version_number: newVersionNumber
                )

                version_bump_podspec(
                    path: 'MobileViews.podspec',
                    version_number: newVersionNumber
                )

                version_bump_podspec(
                    path: 'ViewModels.podspec',
                    version_number: newVersionNumber
                )

                version_bump_podspec(
                    path: 'Models.podspec',
                    version_number: newVersionNumber
                )

                version_bump_podspec(
                    path: 'Services.podspec',
                    version_number: newVersionNumber
                )

                # ===

                commit_version_bump(
                    message: 'Version Bump to ' + newVersionNumber + ' (' + newBuildNumber + ')',
                    xcodeproj: 'AppTemplate.xcodeproj',
                    include: ["Project.spec", "MobileViews.podspec", "ViewModels.podspec", "Models.podspec", "Services.podspec"]
                )

            end # lane :beforeRelease
            """
        }()
        .split(separator: "\n")
        
        //---
        
        let project = try! Spec.Project(
            name: "AppTemplate",
            summary: "The greates app idea ever",
            copyrightYear: 2019,
            deploymentTargets: [
                .iOS : "9.0"
            ],
            location: .use("AppTemplate"),
            shouldReport: false
        )
        
        let modules = try! (
            mobileViews: Spec.Module(
                project: project,
                name: "MobileViews",
                summary: "[View] level types according to MVVMSE.",
                deploymentTargets: project
                    .deploymentTargets
                    .filter{ $0.platform == project.deploymentTargets[0].platform }
            ),
            viewModels: Spec.Module(
                project: project,
                name: "ViewModels",
                summary: "[ViewModel] level types according to MVVMSE."
            ),
            models: Spec.Module(
                project: project,
                name: "Models",
                summary: "[Model] level types according to MVVMSE."
            ),
            services: Spec.Module(
                project: project,
                name: "Services",
                summary: "[Service] level types according to MVVMSE."
            )
        )
        
        let allModules = try! Spec.Module.extractAll(from: modules)
        
        //---
        
        let result = try! Fastlane
            .Fastfile
            .ForApp()
            .beforeRelease(
                project: project,
                otherPodSpecs: allModules
                    .map{ $0.podspecLocation }
            )
            .prepare(
                at: Some.path
            )
            .content
            .split(separator: "\n")
        
        //---
        
        for (i, expected) in targetOutput.enumerated()
        {
            assertThat(expected == result[i])
        }
    }
}
