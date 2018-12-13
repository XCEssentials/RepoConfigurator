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

// @testable
import XCERepoConfigurator

//---

final
class FastlaneTests: FileModelTestsContext
{
    // MARK: Type level members

    static
    var allTests = [
        ("testFileNames", testFileNames),
        ("testDefaultHeader", testDefaultHeader),
        ("testLibraryBeforeReleaseLane", testLibraryBeforeReleaseLane),
        ("testLibraryGenerateProjectViaCPLane", testLibraryGenerateProjectViaCPLane),
        ("testLibraryGenerateProjectViaIceLane", testLibraryGenerateProjectViaIceLane)
        ]

}

//---

extension FastlaneTests
{
    func testFileNames()
    {
        let expectedName = "fastlane/Fastfile"
        
        XCTAssert(Fastlane.Fastfile.fileName == expectedName)
        XCTAssert(Fastlane.Fastfile.ForApp.fileName == expectedName)
        XCTAssert(Fastlane.Fastfile.ForLibrary.fileName == expectedName)
        
        XCTAssert(Fastlane.Fastfile().prepare(targetFolder: "").name == expectedName)
        XCTAssert(Fastlane.Fastfile.ForApp().prepare(targetFolder: "").name == expectedName)
        XCTAssert(Fastlane.Fastfile.ForLibrary().prepare(targetFolder: "").name == expectedName)
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
        
        let model = Fastlane
            .Fastfile()
            .defaultHeader()
            .prepare(
                targetFolder: targetFolderPath
            )
        
        //---
        
        XCTAssert(model.content.trimmingNewLines == targetOutput)
    }
    
    func testLibraryBeforeReleaseLane()
    {
        let cocoaPodsModuleName = "XCEPipeline"
        
        let targetOutput = """
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
                    path: '\(cocoaPodsModuleName).podspec'
                )

                puts 'Current VERSION number: ' + versionNumber

                # === Infer new version number

                newVersionNumber = git_branch.split('/').last

                puts 'New VERSION number: ' + newVersionNumber

                # === Bump version number & commit changes

                version_bump_podspec(
                    path: '\(cocoaPodsModuleName).podspec',
                    version_number: newVersionNumber
                )

                git_commit(
                    path: '\(cocoaPodsModuleName).podspec',
                    message: 'Version Bump to ' + newVersionNumber + ' in Podspec file'
                )

            end # lane :beforeRelease
            """
        
        //---
        
        let model = Fastlane
            .Fastfile
            .ForLibrary()
            .beforeRelease(
                podSpec: [cocoaPodsModuleName]
            )
            .prepare(
                targetFolder: targetFolderPath
            )
        
        //---
        
        XCTAssert(model.content.trimmingNewLines == targetOutput)
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
        
        let model = Fastlane
            .Fastfile
            .ForLibrary()
            .generateProjectViaCP(
                callCocoaPods: .directly
            )
            .prepare(
                targetFolder: targetFolderPath
            )
        
        //---
        
        XCTAssert(model.content.trimmingNewLines == targetOutput)
    }
    
    func testLibraryGenerateProjectViaIceLane()
    {
        let targetOutput = """
            lane :generateProjectViaIce do
            
                # === Regenerate project
            
                # default initial location for any command
                # is inside 'Fastlane' folder
            
                sh 'cd ./.. && rm -rf ".build" && ice xc'
            
            end # lane :generateProjectViaIce
            """
        
        //---
        
        let model = Fastlane
            .Fastfile
            .ForLibrary()
            .generateProjectViaIce(
                derivedPaths: [[".build"]]
            )
            .prepare(
                targetFolder: targetFolderPath
            )
        
        //---
        
        XCTAssert(model.content.trimmingNewLines == targetOutput)
    }
}
