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

import FileKit
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
        ("testLibraryGenerateProjectViaSwiftPMLane", testLibraryGenerateProjectViaSwiftPMLane)
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
        let expectedAbsoluteLocation: Path = Some.path + expectedRelativeLocation
        
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
                .prepare(absolutePrefixLocation: Some.path)
                .location
                == expectedAbsoluteLocation
        )

        assertThat(
            try! Fastlane
                .Fastfile
                .ForApp()
                .prepare(absolutePrefixLocation: Some.path)
                .location
                == expectedAbsoluteLocation
        )

        assertThat(
            try! Fastlane
                .Fastfile
                .ForLibrary()
                .prepare(absolutePrefixLocation: Some.path)
                .location
            == expectedAbsoluteLocation
        )
    }
    
    func testDefaultHeader()
    {
        let targetOutput = """
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
        
        //---
        
        let model = try! Fastlane
            .Fastfile()
            .defaultHeader()
            .prepare(
                absolutePrefixLocation: Some.path
            )
        
        //---
        
        assertThat(model.content == targetOutput)
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
        
        //---
        
        let model = try! Fastlane
            .Fastfile
            .ForLibrary()
            .beforeRelease(
                podspecLocation: .use([cocoaPodsModuleName])
            )
            .prepare(
                absolutePrefixLocation: Some.path
            )
        
        //---
        
        assertThat(model.content == targetOutput)
    }
    
    func testLibraryGenerateProjectViaCPLane()
    {
        let targetOutput = """
            
            lane :generateProjectViaCP do
            
                # === Regenerate project
            
                # default initial location for any command
                # is inside 'Fastlane' folder
            
                sh 'cd ./.. && rm -rf "Xcode" && pod gen --gen-directory="Xcode"'
            
            end # lane :generateProjectViaCP
            """
        
        //---
        
        let model = try! Fastlane
            .Fastfile
            .ForLibrary()
            .generateProjectViaCP(
                callCocoaPods: .directly
            )
            .prepare(
                absolutePrefixLocation: Some.path
            )
        
        //---
        
        assertThat(model.content == targetOutput)
    }
    
    func testLibraryGenerateProjectViaSwiftPMLane()
    {
        let targetOutput = """
            
            lane :generateProjectViaSwiftPM do
            
                # === Regenerate project
            
                # default initial location for any command
                # is inside 'Fastlane' folder
            
                sh 'cd ./.. && rm -rf ".build" && swift package generate-xcodeproj'
            
            end # lane :generateProjectViaSwiftPM
            """
        
        //---
        
        let model = try! Fastlane
            .Fastfile
            .ForLibrary()
            .generateProjectViaSwiftPM(
                derivedPaths: [[".build"]]
            )
            .prepare(
                absolutePrefixLocation: Some.path
            )
        
        //---
        
        assertThat(model.content == targetOutput)
    }
}
