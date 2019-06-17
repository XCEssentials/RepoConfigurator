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

import PathKit

//---

public
enum Defaults
{
    public
    static
    let initialVersionString: VersionString = "0.0.1"

    public
    static
    let initialBuildNumber: BuildNumber = 0

    public
    static
    let specVariable = "s"

    public
    static
    let subSpecVariable = "ss"

    public
    static
    let tstSuffix = "Tests"

    public
    static
    let podsFromSpec = "podspec"

    public
    static
    let minimumFastlaneVersion: VersionString = "2.100.0" // TODO: define dynamically???

    public
    static
    let stagingExportMethod: Fastlane.Fastfile.ForApp.GymArchiveExportMethod = .adHoc

    public
    static
    let archivesExportLocation: Path = [".archives"]

    public
    static
    let cocoapodsVersion: VersionString = "1.5.3" // TODO: define dynamically???

    public
    static
    let releaseGitBranchesRegEx: String = "(release/*|hotfix/*)" // Git-Flow

    public
    static
    let standardIndentation: String = .init(repeating: " ", count: 4)

    public
    static
    let YAMLIndentation: String = .init(repeating: " ", count: 2)

    public
    static
    let licenseFileName = "LICENSE"
    
    public
    static
    let masterSpec: Path = ["Project.spec"]
}
