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
    class ForApp: Fastlane.Fastfile
    {
        // MARK: Type level members
        
        public
        static
        var fileName: String
        {
            return Fastlane.Fastfile.fileName
        }
    }
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
        requireDependencies: Bool = false, // does not work properly yet
        projectName: String,
        getCurrentVersionFromTarget targetName: String? = nil,
        usesCocoapods: Bool = true,
        swiftGenTargets: [String] = [],
        sourceryTargets: [String] = [],
        swiftLintTargets: [String]? = nil
        ) -> Self
    {
        let laneName = #function.split(separator: "(").first!
        let swiftLintTargets = swiftLintTargets ?? [projectName]

        //---

        if
            requireDependencies
        {
            _ = require(
                "struct",
                "cocoapods",
                "xcodeproj"
            )
        }
        
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

            main <<< type(of: self).swiftGenBuildPhase(
                with: main.indentation,
                projectName: projectName,
                targetNames: swiftGenTargets
            )

            main <<< type(of: self).sourceryBuildPhase(
                with: main.indentation,
                projectName: projectName,
                targetNames: sourceryTargets
            )

            main <<< type(of: self).swiftLintBuildPhase(
                with: main.indentation,
                projectName: projectName,
                targetNames: swiftLintTargets
            )
        }

        main <<< """

            end # lane :\(laneName)
            """

        //---

        return self
    }

    func generateProject(
        requireDependencies: Bool = false, // does not work properly yet
        projectName: String,
        usesCocoapods: Bool = true,
        swiftGenTargets: [String] = [],
        sourceryTargets: [String] = [],
        swiftLintTargets: [String]? = nil
        ) -> Self
    {
        let laneName = #function.split(separator: "(").first!
        let swiftLintTargets = swiftLintTargets ?? [projectName]

        //---
        
        if
            requireDependencies
        {
            _ = require(
                "struct",
                "cocoapods",
                "xcodeproj"
            )
        }
        
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

            main <<< type(of: self).swiftGenBuildPhase(
                with: main.indentation,
                projectName: projectName,
                targetNames: swiftGenTargets
            )

            main <<< type(of: self).sourceryBuildPhase(
                with: main.indentation,
                projectName: projectName,
                targetNames: sourceryTargets
            )

            main <<< type(of: self).swiftLintBuildPhase(
                with: main.indentation,
                projectName: projectName,
                targetNames: swiftLintTargets
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

//---

fileprivate
extension Fastlane.Fastfile
{
    static
    func swiftGenBuildPhase(
        with indentation: Indentation,
        projectName: String,
        targetNames: [String]
        ) -> IndentedText
    {
        guard
            !targetNames.isEmpty
        else
        {
            return []
        }

        //---

        let scriptName = "SwiftGen"
        let targetNames = targetNames.map{ "'\($0)'" }.joined(separator: ", ")

        //---

        return """

            # === Add BUILD PHASE script '\(scriptName)'

            # remember, we are in ./fastlane/ folder now...
            fullProjFilePath = Dir.pwd + '/../\(projectName).xcodeproj'

            project = Xcodeproj::Project.open(fullProjFilePath)

            project
                .targets
                .select{ |t| [\(targetNames)].include?(t.name) }
                .each{ |t|

                    thePhase = t.new_shell_script_build_phase('\(scriptName)')
                    thePhase.shell_script = '"$PODS_ROOT/SwiftGen/bin/swiftgen" config run --config ".swiftgen.yml"'
                    # thePhase.run_only_for_deployment_postprocessing = '1'

                    # now lets put the newly added phase before sources compilation phase
                    t.build_phases.delete(thePhase)
                    t.build_phases.unshift(thePhase)
                }

            project.save()
            """
            .asIndentedText(with: indentation)
    }

    static
    func sourceryBuildPhase(
        with indentation: Indentation,
        projectName: String,
        targetNames: [String]
        ) -> IndentedText
    {
        guard
            !targetNames.isEmpty
        else
        {
            return []
        }

        //---

        let scriptName = "Sourcery"
        let targetNames = targetNames.map{ "'\($0)'" }.joined(separator: ", ")

        //---

        return """

            # === Add BUILD PHASE script '\(scriptName)'

            # remember, we are in ./fastlane/ folder now...
            fullProjFilePath = Dir.pwd + '/../\(projectName).xcodeproj'

            project = Xcodeproj::Project.open(fullProjFilePath)

            project
                .targets
                .select{ |t| [\(targetNames)].include?(t.name) }
                .each{ |t|

                    thePhase = t.new_shell_script_build_phase('\(scriptName)')
                    thePhase.shell_script = '"$PODS_ROOT/Sourcery/bin/sourcery" --prune'
                    # thePhase.run_only_for_deployment_postprocessing = '1'

                    # now lets put the newly added phase before sources compilation phase
                    t.build_phases.delete(thePhase)
                    t.build_phases.unshift(thePhase)

                }

            project.save()
            """
            .asIndentedText(with: indentation)
    }

    static
    func swiftLintBuildPhase(
        with indentation: Indentation,
        projectName: String,
        targetNames: [String]
        ) -> IndentedText
    {
        guard
            !targetNames.isEmpty
        else
        {
            return []
        }

        //---

        let scriptName = "SwiftLintPods"
        let targetNames = targetNames.map{ "'\($0)'" }.joined(separator: ", ")

        //---

        return """

            # === Add BUILD PHASE script '\(scriptName)'

            # remember, we are in ./fastlane/ folder now...
            fullProjFilePath = Dir.pwd + '/../\(projectName).xcodeproj'

            project = Xcodeproj::Project.open(fullProjFilePath)

            project
                .targets
                .select{ |t| [\(targetNames)].include?(t.name) }
                .each{ |t|

                    thePhase = t.new_shell_script_build_phase('\(scriptName)')
                    thePhase.shell_script = '"${PODS_ROOT}/SwiftLint/swiftlint"'
                    # thePhase.run_only_for_deployment_postprocessing = '1'

                    t.build_phases.delete(thePhase)
                    t.build_phases.unshift(thePhase)

                }

            project.save()
            """
            .asIndentedText(with: indentation)
    }
}
