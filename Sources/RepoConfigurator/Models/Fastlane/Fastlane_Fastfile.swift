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
    struct Fastfile: FixedNameTextFile
    {
        // MARK: - Type level members

        public
        struct Section
        {
            // MARK: - Type level members

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

            // MARK: - Instance level members

            public private(set)
            var content: [IndentedTextGetter] = []
        }

        // MARK: - Instance level members

        public private(set)
        var fileContent: [IndentedTextGetter] = []
    }
}

// MARK: - Presets

public
extension Fastlane.Fastfile
{
    public
    static
    func custom(
        predefinedSections: [Section] = [],
        otherEntries: String...
        ) -> Fastlane.Fastfile
    {
        var content: [IndentedTextGetter] = []

        //---

        content <<< predefinedSections

        content <<< otherEntries

        //---

        return .init(fileContent: content)
    }

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
        swiftLintGlobalTargets: [String]? = nil,
        swiftLintPodsTargets: [String] = [],
        stagingSchemeName: String? = nil,
        stagingExportMethod: Section.ArchiveExportMethod = Defaults.stagingExportMethod,
        archivesExportPath: String = Defaults.archivesExportPath,
        otherEntries: String...
        ) -> Fastlane.Fastfile
    {
        let projectName = projectName ?? productName
        let swiftLintGlobalTargets = swiftLintGlobalTargets ?? [projectName]
        let stagingSchemeName = stagingSchemeName ?? productName

        //---

        let sections: [Section] = [

            .defaultHeader(
                optOutUsage: optOutUsage,
                autoUpdateFastlane: autoUpdateFastlane,
                minimumFastlaneVersion: minimumFastlaneVersion
            ),
            .beforeRelease(
                ensureGitBranch: releaseBranches,
                projectName: projectName,
                cocoaPodsModuleName: nil // N/A, it's an app!
            ),
            .regenerateProject(
                projectName: projectName,
                getCurrentVersionFromTarget: currentVersionTargetName,
                usesCocoapods: usesCocoapods,
                swiftGenTargets: swiftGenTargets,
                sourceryTargets: sourceryTargets,
                swiftLintGlobalTargets: swiftLintGlobalTargets,
                swiftLintPodsTargets: swiftLintPodsTargets
            ),
            .generateProject(
                projectName: projectName,
                usesCocoapods: usesCocoapods,
                swiftGenTargets: swiftGenTargets,
                sourceryTargets: sourceryTargets,
                swiftLintGlobalTargets: swiftLintGlobalTargets,
                swiftLintPodsTargets: swiftLintPodsTargets
            ),
            .archiveBeta(
                productName: productName,
                projectName: projectName,
                schemeName: stagingSchemeName,
                exportMethod: stagingExportMethod,
                archivesExportPath: archivesExportPath
            )
        ]

        //---

        return .init(
            fileContent: sections.map{ $0.asIndentedText }
                + otherEntries.map{ $0.asIndentedText }
        )
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
        swiftLintGlobalTargets: [String]? = nil,
        swiftLintPodsTargets: [String] = [],
        otherEntries: String...
        ) -> Fastlane.Fastfile
    {
        let projectName = projectName ?? productName
        let swiftLintGlobalTargets = swiftLintGlobalTargets ?? [projectName]

        //---

        let sections: [Section] = [

            .defaultHeader(
                optOutUsage: optOutUsage,
                autoUpdateFastlane: autoUpdateFastlane,
                minimumFastlaneVersion: minimumFastlaneVersion
            ),
            .beforeRelease(
                ensureGitBranch: releaseBranches,
                projectName: projectName,
                cocoaPodsModuleName: cocoaPodsModuleName
            ),
            .regenerateProject(
                projectName: projectName,
                getCurrentVersionFromTarget: currentVersionTargetName,
                usesCocoapods: usesCocoapods,
                swiftGenTargets: swiftGenTargets,
                sourceryTargets: sourceryTargets,
                swiftLintGlobalTargets: swiftLintGlobalTargets,
                swiftLintPodsTargets: swiftLintPodsTargets
            ),
            .generateProject(
                projectName: projectName,
                usesCocoapods: usesCocoapods,
                swiftGenTargets: swiftGenTargets,
                sourceryTargets: sourceryTargets,
                swiftLintGlobalTargets: swiftLintGlobalTargets,
                swiftLintPodsTargets: swiftLintPodsTargets
            )
        ]

        //---

        return .init(
            fileContent: sections.map{ $0.asIndentedText }
                + otherEntries.map{ $0.asIndentedText }
        )
    }
}

// MARK: - Content rendering

extension Fastlane.Fastfile.Section: TextFilePiece
{
    public
    func asIndentedText(
        with indentation: inout Indentation
        ) -> IndentedText
    {
        return content.asIndentedText(with: &indentation)
    }
}

public
extension Fastlane.Fastfile.Section
{
    static
    func defaultHeader(
        optOutUsage: Bool = false,
        autoUpdateFastlane: Bool = false,
        minimumFastlaneVersion: VersionString = Defaults.minimumFastlaneVersion
        ) -> Fastlane.Fastfile.Section
    {
        return .init(
            content: [

                //swiftlint:disable line_length

                """
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
                .asIndentedText

                //swiftlint:enable line_length
            ]
        )
    }

    static
    func beforeRelease(
        ensureGitBranch: String? = Defaults.releaseGitBranchesRegEx,
        projectName: String,
        cocoaPodsModuleName: String? // pass 'nil' if should not maintain podspec file
        ) -> Fastlane.Fastfile.Section
    {
        var content: [IndentedTextGetter] = []

        //---

        content <<< """

            lane :beforeRelease do
            """

        content <<< ensureGitBranch.map{ """

                ensure_git_branch(
                    branch: '\($0)'
                )
            """
        }

        content <<< """

                ensure_git_status_clean
            """

        content <<< (cocoaPodsModuleName != nil).mapIf(true){ """

                # ===

                pod_lib_lint(
                    allow_warnings: true,
                    quick: true
                )
            """
        }

        content <<< """

                # ===

                versionNumber = get_version_number(
                    xcodeproj: '\(projectName).xcodeproj'
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

        content <<< cocoaPodsModuleName.map{ """

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

        content <<< """

            end # lane :beforeRelease
            """

        //---

        return .init(content: content)
    }

    static
    func regenerateProject(
        projectName: String,
        getCurrentVersionFromTarget targetName: String? = nil,
        usesCocoapods: Bool = true,
        swiftGenTargets: [String] = [],
        sourceryTargets: [String] = [],
        swiftLintGlobalTargets: [String]? = nil,
        swiftLintPodsTargets: [String] = []
        ) -> Fastlane.Fastfile.Section
    {
        let swiftLintGlobalTargets = swiftLintGlobalTargets ?? [projectName]

        //---

        let getter: IndentedTextGetter = {

            indentation in

            //---

            var result: IndentedText = []

            //---

            result <<< """

                lane :REgenerateProject do

                    # === Remember current version and build numbers

                    versionNumber = get_version_number(
                        xcodeproj: '\(projectName).xcodeproj',
                        target: '\(targetName ?? projectName)'
                    )

                    buildNumber = get_build_number(
                        xcodeproj: '\(projectName).xcodeproj',
                        target: '\(targetName ?? projectName)'
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
                .asIndentedText(with: &indentation)

            indentation++

            result <<< swiftGenBuildPhase(
                with: &indentation,
                projectName: projectName,
                targetNames: swiftGenTargets
            )

            result <<< sourceryBuildPhase(
                with: &indentation,
                projectName: projectName,
                targetNames: sourceryTargets
            )

            result <<< swiftLintGlobalBuildPhase(
                with: &indentation,
                projectName: projectName,
                targetNames: swiftLintGlobalTargets
            )

            result <<< swiftLintPodsBuildPhase(
                with: &indentation,
                projectName: projectName,
                targetNames: swiftLintPodsTargets
            )

            indentation--

            result <<< """

                end # lane :REgenerateProject
                """
                .asIndentedText(with: &indentation)

            //---

            return result
        }

        //---

        return .init(content: [getter])
    }

    static
    func generateProject(
        projectName: String,
        usesCocoapods: Bool = true,
        swiftGenTargets: [String] = [],
        sourceryTargets: [String] = [],
        swiftLintGlobalTargets: [String]? = nil,
        swiftLintPodsTargets: [String] = []
        ) -> Fastlane.Fastfile.Section
    {
        let swiftLintGlobalTargets = swiftLintGlobalTargets ?? [projectName]

        //---

        let getter: IndentedTextGetter = {

            indentation in

            //---

            var result: IndentedText = []

            //---

            result <<< """

                lane :generateProject do

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
                .asIndentedText(with: &indentation)

            indentation++

            result <<< swiftGenBuildPhase(
                with: &indentation,
                projectName: projectName,
                targetNames: swiftGenTargets
            )

            result <<< sourceryBuildPhase(
                with: &indentation,
                projectName: projectName,
                targetNames: sourceryTargets
            )

            result <<< swiftLintGlobalBuildPhase(
                with: &indentation,
                projectName: projectName,
                targetNames: swiftLintGlobalTargets
            )

            result <<< swiftLintPodsBuildPhase(
                with: &indentation,
                projectName: projectName,
                targetNames: swiftLintPodsTargets
            )

            indentation--

            result <<< """

                end # lane :generateProject
                """
                .asIndentedText(with: &indentation)

            //---

            return result
        }

        //---

        return .init(content: [getter])
    }

    static
    func archiveBeta(
        productName: String,
        projectName: String? = nil, // 'productName' will be used if 'nil'
        schemeName: String? = nil, // 'productName' will be used if 'nil'
        exportMethod: ArchiveExportMethod = Defaults.stagingExportMethod,
        archivesExportPath: String = Defaults.archivesExportPath
        ) -> Fastlane.Fastfile.Section
    {
        let projectName = projectName ?? productName
        let schemeName = schemeName ?? productName

        //---

        let getter = """

            lane :archiveBeta do

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

            end # lane :archiveBeta
            """
            .asIndentedText

        //---

        return .init(content: [getter])
    }
}

//internal
extension Fastlane.Fastfile.Section
{
    static
    func swiftGenBuildPhase(
        with indentation: inout Indentation,
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
            .asIndentedText(with: &indentation)
    }

    static
    func sourceryBuildPhase(
        with indentation: inout Indentation,
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
            .asIndentedText(with: &indentation)
    }

    static
    func swiftLintGlobalBuildPhase(
        with indentation: inout Indentation,
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

        let scriptName = "SwiftLintGlobal"
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
                    thePhase.shell_script = 'if which swiftlint >/dev/null; then
                        swiftlint
                    else
                        echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
                    fi'
                    # thePhase.run_only_for_deployment_postprocessing = '1'

                    t.build_phases.delete(thePhase)
                    t.build_phases.unshift(thePhase)

                }

            project.save()
            """
            .asIndentedText(with: &indentation)
    }

    static
    func swiftLintPodsBuildPhase(
        with indentation: inout Indentation,
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
            .asIndentedText(with: &indentation)
    }
}
