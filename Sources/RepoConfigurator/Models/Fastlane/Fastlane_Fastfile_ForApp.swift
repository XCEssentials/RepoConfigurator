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

public
extension Fastlane.Fastfile
{
    public
    final
    class ForApp: Fastlane.Fastfile {}
}

//---

public
extension Fastlane.Fastfile.ForApp
{
    func beforeRelease(
        ensureGitBranch: String? = Defaults.releaseGitBranchesRegEx,
        projectName: String,
        getCurrentVersionFromTarget targetName: String? = nil
        ) -> Self
    {
        let laneName = #function.split(separator: "(").first!

        //---

        main <<< """

            lane :\(laneName) do
            """

        main.indentation.nest{

            main <<< ensureGitBranch.map{ """

                ensure_git_branch(
                    branch: '\($0)'
                )
                """
            }

            main <<< """

                ensure_git_status_clean
                """

            main <<< """

                # === Remember current version number

                versionNumber = get_version_number(
                    xcodeproj: '\(projectName).xcodeproj',
                    target: '\(targetName ?? projectName)'
                )

                puts 'Current VERSION number: ' + versionNumber

                # === Infer new version number

                defaultNewVersion = git_branch.split('/').last

                # === Define new version number

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

                # === Apply NEW version number and increment build number

                increment_version_number(
                    xcodeproj: '\(projectName).xcodeproj',
                    version_number: newVersionNumber
                )

                increment_build_number(
                    xcodeproj: '\(projectName).xcodeproj'
                )

                # ===

                newBuildNumber = get_build_number(
                    xcodeproj: '\(projectName).xcodeproj'
                )

                commit_version_bump( # it will fail if more than version bump
                    xcodeproj: '\(projectName).xcodeproj',
                    message: 'Version Bump to ' + newVersionNumber + ' (' + newBuildNumber + ')'
                )
                """
        }

        main <<< """

            end # lane :\(laneName)
            """

        //---

        return self
    }

    func regenerateProject(
        projectName: String,
        getCurrentVersionFromTarget targetName: String? = nil,
        usesCocoapods: Bool = true,
        // TODO: Use [ExtraScriptBuildPhase] instead!
        swiftGenTargets: [String] = [],
        sourceryTargets: [String] = [],
        swiftLintTargets: [String]? = nil
        ) -> Self
    {
        let laneName = #function.split(separator: "(").first!
        let swiftLintTargets = swiftLintTargets ?? [projectName]

        //---

        _ = require(
            "struct",
            "cocoapods",
            "xcodeproj"
        )
        
        //---

        main <<< """

            lane :\(laneName) do

            """

        main.indentation.nest{

            main <<< """
                # === Remember current version and build numbers

                versionNumber = get_version_number(
                    xcodeproj: '\(projectName).xcodeproj',
                    target: '\(targetName ?? projectName)'
                )

                buildNumber = get_build_number(
                    xcodeproj: '\(projectName).xcodeproj'
                )

                # === Remove completely current project file/package

                # default initial location for any command
                # is inside 'Fastlane' folder

                sh 'cd ./.. && rm -r ./\(projectName).xcodeproj'

                # === Regenerate project

                # default initial location for any command
                # is inside 'Fastlane' folder

                sh 'cd ./.. && struct generate\(usesCocoapods ? " && pod install" : "")'

                # === Set proper current version and build numbers

                increment_version_number(
                    xcodeproj: '\(projectName).xcodeproj',
                    version_number: versionNumber
                )

                increment_build_number(
                    xcodeproj: '\(projectName).xcodeproj',
                    build_number: buildNumber
                )

                # === Sort all project entries

                # default initial location for any command
                # is inside 'Fastlane' folder

                sh 'cd ./.. && xcodeproj sort "\(projectName).xcodeproj"'
                """

            swiftGenBuildPhase(
                projectName: projectName,
                targetNames: swiftGenTargets
            )

            sourceryBuildPhase(
                projectName: projectName,
                targetNames: sourceryTargets
            )

            swiftLintBuildPhase(
                projectName: projectName,
                targetNames: swiftLintTargets,
                params: []
            )
        }

        main <<< """

            end # lane :\(laneName)
            """

        //---

        return self
    }

    func generateProject(
        projectName: String,
        usesCocoapods: Bool = true,
        // TODO: Use [ExtraScriptBuildPhase] instead!
        swiftGenTargets: [String] = [],
        sourceryTargets: [String] = [],
        swiftLintTargets: [String]? = nil
        ) -> Self
    {
        let laneName = #function.split(separator: "(").first!
        let swiftLintTargets = swiftLintTargets ?? [projectName]

        //---
        
        _ = require(
            "struct",
            "cocoapods",
            "xcodeproj"
        )
        
        //---

        main <<< """

            lane :generateProject do

            """

        main.indentation.nest{

            main <<< """
                # === Generate project from scratch

                # default initial location for any command
                # is inside 'Fastlane' folder

                sh 'cd ./.. && struct generate\(usesCocoapods ? " && pod update" : "")'

                # === Set proper build number

                # NOTE: proper version number is stored in the Info files

                newBuildNumber = prompt(
                    text: 'Desired BUILD number:'
                )

                increment_build_number(
                    xcodeproj: '\(projectName).xcodeproj',
                    build_number: newBuildNumber
                )

                # === Sort all project entries

                # default initial location for any command
                # is inside 'Fastlane' folder

                sh 'cd ./.. && xcodeproj sort "\(projectName).xcodeproj"'
                """

            swiftGenBuildPhase(
                projectName: projectName,
                targetNames: swiftGenTargets
            )

            sourceryBuildPhase(
                projectName: projectName,
                targetNames: sourceryTargets
            )

            swiftLintBuildPhase(
                projectName: projectName,
                targetNames: swiftLintTargets,
                params: []
            )
        }

        main <<< """

            end # lane :\(laneName)
            """

        //---

        return self
    }

    func archiveBeta(
        productName: String,
        projectName: String? = nil, // 'productName' will be used if 'nil'
        schemeName: String? = nil, // 'productName' will be used if 'nil'
        exportMethod: Fastlane.Fastfile.ArchiveExportMethod = Defaults.stagingExportMethod,
        archivesExportPath: String = Defaults.archivesExportPath
        ) -> Self
    {
        let laneName = #function.split(separator: "(").first!
        let projectName = projectName ?? productName
        let schemeName = schemeName ?? productName

        //---

        //swiftlint:disable line_length

        main <<< """

            lane :\(laneName) do

                ensure_git_status_clean

                # === Set basic parameters

                buildNumber = get_build_number(
                    xcodeproj: '\(projectName).xcodeproj'
                )

                versionNumber = get_version_number(
                    xcodeproj: '\(projectName).xcodeproj'
                )

                puts 'Attempt to use SCHEME: \(schemeName)'

                # === Check if target version number is eligible for this line

                # project must be on version number 'X.Y.Z-beta.*'

                if (!(versionNumber.include? 'dirty') && (versionNumber.include? 'beta'))

                    # git status is clean at this point

                    # === main part

                    # seems to be allowed to run this lane

                    gym(
                        scheme: '\(schemeName)',
                        export_method: '\(exportMethod.rawValue)',
                        output_name: '\(productName)_' + versionNumber + '_' + buildNumber + '.ipa',
                        output_directory: '\(archivesExportPath)'
                    )

                    # === mark dirty

                    # puts 'NOTE: Mark project version as dirty now.'

                    newVersionNumber = versionNumber + '+dirty'
                    newBuildNumber = buildNumber

                    increment_version_number(
                        xcodeproj: '\(projectName).xcodeproj',
                        version_number: newVersionNumber
                    )

                    # only set 'dirty' mark in 'versionNumber'!

                    commit_version_bump(
                        xcodeproj: '\(projectName).xcodeproj',
                        message: 'Version Bump to ' + newVersionNumber + ' (' + newBuildNumber + ')'
                    )

                else

                    puts 'ERROR: This VERSION (' + versionNumber + ') of the app can NOT be archived using this lane.'
                    puts 'NOTE: this lane is for beta (STAGING) builds ONLY.'

                end

            end # lane :\(laneName)
            """

        //swiftlint:enable line_length

        //---

        return self
    }
}
