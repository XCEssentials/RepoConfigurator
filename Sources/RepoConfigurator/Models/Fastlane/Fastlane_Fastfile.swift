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

extension Fastlane
{
    public
    final
    class Fastfile: FixedNameTextFile
    {
        // MARK: Type level members

        /**
         Method used to export the archive.
         Valid values are: app-store, ad-hoc, package, enterprise, development, developer-id.
         See more: https://docs.fastlane.tools/actions/gym/#parameters
         */
        public
        enum ArchiveExportMethod: String
        {
            case appStore = "app-store"
            case adHoc = "ad-hoc"
            case package = "package"
            case enterprise = "enterprise"
            case development = "development"
            case developerId = "developer-id"
        }

        // MARK: Instance level members

        private
        var header: IndentedTextBuffer = .init()
        
        private
        var requiredGems: Set<String> = []

        private
        var main: IndentedTextBuffer = .init()

        public
        var fileContent: IndentedText
        {
            return header.content
                + requiredGems.sorted().asIndentedText(with: .init())
                + main.content
        }

        // MARK: Initializers

        public
        init() {}
    }
}

// MARK: - Presets

public
extension Fastlane.Fastfile
{
    public
    static
    func app(
        optOutUsage: Bool = false,
        autoUpdateFastlane: Bool = false,
        minimumFastlaneVersion: VersionString = Defaults.minimumFastlaneVersion,
        releaseBranches: String = Defaults.releaseGitBranchesRegEx,
        productName: String,
        projectName: String? = nil,
        getCurrentVersionFromTarget currentVersionTargetName: String? = nil,
        usesCocoapods: Bool = true,
        swiftGenTargets: [String] = [],
        sourceryTargets: [String] = [],
        swiftLintTargets: [String]? = nil,
        stagingSchemeName: String? = nil,
        stagingExportMethod: ArchiveExportMethod = Defaults.stagingExportMethod,
        archivesExportPath: String = Defaults.archivesExportPath,
        otherEntries: [String] = []
        ) -> Fastlane.Fastfile
    {
        let projectName = projectName ?? productName
        let swiftLintTargets = swiftLintTargets ?? [projectName]
        let stagingSchemeName = stagingSchemeName ?? productName

        //---

        let result = self
            .init()
            .defaultHeader(
                optOutUsage: optOutUsage,
                autoUpdateFastlane: autoUpdateFastlane,
                minimumFastlaneVersion: minimumFastlaneVersion
            )
            .beforeRelease(
                ensureGitBranch: releaseBranches,
                projectName: projectName,
                getCurrentVersionFromTarget: currentVersionTargetName,
                cocoaPodsModuleName: nil // N/A, it's an app!
            )
            .regenerateProject(
                projectName: projectName,
                getCurrentVersionFromTarget: currentVersionTargetName,
                usesCocoapods: usesCocoapods,
                swiftGenTargets: swiftGenTargets,
                sourceryTargets: sourceryTargets,
                swiftLintTargets: swiftLintTargets
            )
            .generateProject(
                projectName: projectName,
                usesCocoapods: usesCocoapods,
                swiftGenTargets: swiftGenTargets,
                sourceryTargets: sourceryTargets,
                swiftLintTargets: swiftLintTargets
            )
            .archiveBeta(
                productName: productName,
                projectName: projectName,
                schemeName: stagingSchemeName,
                exportMethod: stagingExportMethod,
                archivesExportPath: archivesExportPath
            )

        otherEntries.forEach{

            _ = result.custom($0)
        }

        //---

        return result
    }

    public
    static
    func framework(
        optOutUsage: Bool = false,
        autoUpdateFastlane: Bool = false,
        minimumFastlaneVersion: VersionString = Defaults.minimumFastlaneVersion,
        releaseBranches: String = Defaults.releaseGitBranchesRegEx,
        productName: String,
        getCurrentVersionFromTarget currentVersionTargetName: String? = nil,
        cocoaPodsModuleName: String?, // pass 'nil' if should not maintain podspec file
        projectName: String? = nil, // 'productName' wil be used as fallback
        usesCocoapods: Bool = true,
        swiftGenTargets: [String] = [],
        sourceryTargets: [String] = [],
        swiftLintTargets: [String]? = nil,
        otherEntries: [String] = []
        ) -> Fastlane.Fastfile
    {
        let projectName = projectName ?? productName
        let swiftLintTargets = swiftLintTargets ?? [projectName]

        //---

        let result = self
            .init()
            .defaultHeader(
                optOutUsage: optOutUsage,
                autoUpdateFastlane: autoUpdateFastlane,
                minimumFastlaneVersion: minimumFastlaneVersion
            )
            .beforeRelease(
                ensureGitBranch: releaseBranches,
                projectName: projectName,
                getCurrentVersionFromTarget: currentVersionTargetName,
                cocoaPodsModuleName: cocoaPodsModuleName
            )
            .regenerateProject(
                projectName: projectName,
                getCurrentVersionFromTarget: currentVersionTargetName,
                usesCocoapods: usesCocoapods,
                swiftGenTargets: swiftGenTargets,
                sourceryTargets: sourceryTargets,
                swiftLintTargets: swiftLintTargets
            )
            .generateProject(
                projectName: projectName,
                usesCocoapods: usesCocoapods,
                swiftGenTargets: swiftGenTargets,
                sourceryTargets: sourceryTargets,
                swiftLintTargets: swiftLintTargets
            )

        otherEntries.forEach{

            _ = result.custom($0)
        }

        //---

        return result
    }
}

// MARK: - Content rendering

public
extension Fastlane.Fastfile
{
    func defaultHeader(
        optOutUsage: Bool = false,
        autoUpdateFastlane: Bool = false,
        minimumFastlaneVersion: VersionString = Defaults.minimumFastlaneVersion
        ) -> Fastlane.Fastfile
    {
        //swiftlint:disable line_length

        header <<< """
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
            \(optOutUsage ? "" : "# ")opt_out_usage

            # If you want to automatically update fastlane if a new version is available:
            \(autoUpdateFastlane ? "" : "# ")update_fastlane

            # This is the minimum version number required.
            # Update this, if you use features of a newer version
            fastlane_version '\(minimumFastlaneVersion)'

            """

        //swiftlint:enable line_length

        //---

        return self
    }

    func require(
        _ gems: String...
        ) -> Fastlane.Fastfile
    {
        gems.joined(separator: "\n")
            .split(separator: "\n")
            .map{ "fastlane_require '\($0)'" }
            .forEach{ requiredGems.insert($0) }
     
        //---
        
        return self
    }
    
    func beforeRelease(
        ensureGitBranch: String? = Defaults.releaseGitBranchesRegEx,
        projectName: String,
        getCurrentVersionFromTarget targetName: String? = nil,
        cocoaPodsModuleName: String? // pass 'nil' if should not maintain podspec file
        ) -> Fastlane.Fastfile
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

            main <<< (cocoaPodsModuleName != nil).mapIf(true){ """

                # ===

                pod_lib_lint(
                    allow_warnings: true,
                    quick: true
                )
                """
            }

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

            main <<< cocoaPodsModuleName.map{ """

                # ===

                version_bump_podspec(
                    path: './\($0).podspec',
                    version_number: newVersionNumber
                )

                git_commit(
                    path: './\($0).podspec',
                    message: 'Version Bump to ' + newVersionNumber + ' in Podspec file'
                )
                """
            }
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
        swiftGenTargets: [String] = [],
        sourceryTargets: [String] = [],
        swiftLintTargets: [String]? = nil
        ) -> Fastlane.Fastfile
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
        projectName: String,
        usesCocoapods: Bool = true,
        swiftGenTargets: [String] = [],
        sourceryTargets: [String] = [],
        swiftLintTargets: [String]? = nil
        ) -> Fastlane.Fastfile
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
        ) -> Fastlane.Fastfile
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

    func custom(
        _ customEntry: String
        ) -> Fastlane.Fastfile
    {
        main <<< customEntry

        //---

        return self
    }
}

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
