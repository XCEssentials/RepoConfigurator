extension Fastlane
{
    public
    struct Fastfile: FixedNameTextFile, ConfigurableTextFile
    {
        // MARK: - Type level members

        public
        static
        let fileName = "fastlane/Fastfile"

        public
        enum SwiftLintLocation
        {
            case none
            case global
            case cocoaPods
        }

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

        public
        enum Section: TextFilePiece
        {
            case defaultHeader

            case fastlaneVersion(VersionString)

            case beforeRelease(
                projectName: String,
                podspecModuleName: String?
            )

            case regenerateProject(
                projectName: String,
                usesCocoapods: Bool,
                usesSwiftGen: Bool,
                usesSourcery: Bool,
                usesSwiftLint: SwiftLintLocation
            )

            case setupProjectFromScratch(
                projectName: String,
                usesCocoapods: Bool,
                usesSwiftGen: Bool,
                usesSourcery: Bool,
                usesSwiftLint: SwiftLintLocation
            )

            // beta-version builds
            case archiveStaging(
                projectName: String,
                schemeName: String,
                exportMethod: ArchiveExportMethod,
                productName: String,
                archivesExportPath: String
            )
        }

        // MARK: - Instance level members

        public
        var fileContent: IndentedText = []

        // MARK: - Initializers

        public
        init() {}

        // MARK: - Aliases

        public
        typealias Itself = Fastfile
    }
}

// MARK: - Presets

public
extension Fastlane.Fastfile
{
    public
    static
    func app(
        fastlaneVersion: VersionString,
        projectName: String,
        productName: String,
        podspecModuleName: String?,
        usesCocoapods: Bool,
        usesSwiftGen: Bool,
        usesSourcery: Bool,
        usesSwiftLint: SwiftLintLocation,
        stagingSchemeName: String,
        stagingExportMethod: ArchiveExportMethod,
        archivesExportPath: String
        ) -> Itself
    {
        return Itself(
            .defaultHeader,
            .fastlaneVersion(
                fastlaneVersion
            ),
            .beforeRelease(
                projectName: projectName,
                podspecModuleName: podspecModuleName
            ),
            .regenerateProject(
                projectName: projectName,
                usesCocoapods: usesCocoapods,
                usesSwiftGen: usesSwiftGen,
                usesSourcery: usesSourcery,
                usesSwiftLint: usesSwiftLint
            ),
            .setupProjectFromScratch(
                projectName: projectName,
                usesCocoapods: usesCocoapods,
                usesSwiftGen: usesSwiftGen,
                usesSourcery: usesSourcery,
                usesSwiftLint: usesSwiftLint
            ),
            .archiveStaging(
                projectName: projectName,
                schemeName: stagingSchemeName,
                exportMethod: stagingExportMethod,
                productName: productName,
                archivesExportPath: archivesExportPath
            )
        )
    }

    public
    static
    func framework(
        fastlaneVersion: VersionString,
        projectName: String,
        podspecModuleName: String?,
        usesCocoapods: Bool,
        usesSwiftGen: Bool,
        usesSourcery: Bool,
        usesSwiftLint: SwiftLintLocation
        ) -> Itself
    {
        return Itself(
            .defaultHeader,
            .fastlaneVersion(
                fastlaneVersion
            ),
            .beforeRelease(
                projectName: projectName,
                podspecModuleName: podspecModuleName
            ),
            .regenerateProject(
                projectName: projectName,
                usesCocoapods: usesCocoapods,
                usesSwiftGen: usesSwiftGen,
                usesSourcery: usesSourcery,
                usesSwiftLint: usesSwiftLint
            ),
            .setupProjectFromScratch(
                projectName: projectName,
                usesCocoapods: usesCocoapods,
                usesSwiftGen: usesSwiftGen,
                usesSourcery: usesSourcery,
                usesSwiftLint: usesSwiftLint
            )
        )
    }
}

// MARK: - Content rendering

public
extension Fastlane.Fastfile.Section
{
    func asIndentedText(
        with indentation: inout Indentation
        ) -> IndentedText
    {
        // NOTE: depends on 'Xcodeproj' CL tool

        var result: IndentedText = []

        //---

        switch self
        {
            case .defaultHeader:
                result <<< """

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
                    """
                    .asIndentedText(with: &indentation)

            case .fastlaneVersion(
                let version
                ):
                result <<< """

                    # This is the minimum version number required.
                    # Update this, if you use features of a newer version
                    fastlane_version '\(version)'

                    """
                    .asIndentedText(with: &indentation)

            case .beforeRelease(
                let projectName,
                let podspecModuleName
                ):
                result <<< """

                    lane :beforeRelease do

                        ensure_git_branch(
                            branch: 'release/*'
                        )

                        # ===

                        ensure_git_status_clean

                        # ===

                        pod_lib_lint(
                            allow_warnings: true,
                            quick: true
                        )

                        # ===

                        versionNumber = get_version_number(xcodeproj: '\(projectName).xcodeproj')
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

                            newVersionNumber = prompt(text: 'New VERSION number:')

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

                        newBuildNumber = get_build_number(xcodeproj: '\(projectName).xcodeproj')

                        commit_version_bump( # it will fail if more than version bump
                            xcodeproj: '\(projectName).xcodeproj',
                            message: 'Version Bump to ' + newVersionNumber + ' (' + newBuildNumber + ')'
                        )
                    """
                    .asIndentedText(with: &indentation)

                indentation++

                if
                    let podspecModuleName = podspecModuleName
                {
                    result <<< """

                        # ===

                        version_bump_podspec(
                        path: './\(podspecModuleName).podspec',
                        version_number: newVersionNumber
                        )

                        git_commit(
                        path: './\(podspecModuleName).podspec',
                        message: 'Version Bump to ' + newVersionNumber + ' in Podspec file'
                        )
                        """
                        .asIndentedText(with: &indentation)
                }

                indentation--

                result <<< """

                    end
                    """
                    .asIndentedText(with: &indentation)

            case .regenerateProject(
                let projectName,
                let usesCocoapods,
                let usesSwiftGen,
                let usesSourcery,
                let usesSwiftLint
                ):
                result <<<  """

                    lane :resetProject do

                        # === Remember current version and build numbers

                        versionNumber = get_version_number(xcodeproj: '\(projectName).xcodeproj')
                        buildNumber = get_build_number(xcodeproj: '\(projectName).xcodeproj')

                        # === Remove completely current project file/package

                        sh 'cd ./.. && rm -r ./\(projectName).xcodeproj'

                        # === Regenerate project

                        # default initial location for any command
                        # is inside 'Fastlane' folder

                        sh 'cd ./.. && struct generate \(usesCocoapods ? "" : "#")&& pod install'

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

                        sh 'cd ./.. && xcodeproj sort "\(projectName).xcodeproj"'

                        # === Add custom 'Run Script Phase' entries
                    """
                    .asIndentedText(with: &indentation)

                indentation++

                if
                    usesSwiftGen
                {
                    result <<< swiftGenBuildPhase(
                        projectFileName: projectName
                        )
                        .asIndentedText(with: &indentation)
                }

                if
                    usesSourcery
                {
                    result <<< sourceryBuildPhase(
                        projectFileName: projectName
                        )
                        .asIndentedText(with: &indentation)
                }

                if
                    usesSwiftLint == .global
                {
                    result <<< swiftLintGlobalBuildPhase(
                        projectFileName: projectName
                        )
                        .asIndentedText(with: &indentation)
                }

                if
                    usesSwiftLint == .cocoaPods
                {
                    result <<< swiftLintCocoaPodsBuildPhase(
                        projectFileName: projectName
                        )
                        .asIndentedText(with: &indentation)
                }

                indentation--

                result <<< """

                    end
                    """
                    .asIndentedText(with: &indentation)

            case .setupProjectFromScratch(
                let projectName,
                let usesCocoapods,
                let usesSwiftGen,
                let usesSourcery,
                let usesSwiftLint
                ):
                result <<<  """

                    lane :setupProject do

                        # === Generate project from scratch

                        # default initial location for any command
                        # is inside 'Fastlane' folder

                        sh 'cd ./.. && struct generate \(usesCocoapods ? "" : "#")&& pod update'

                        # === Set proper build number

                        # NOTE: proper version number is stored in the Info file

                        newBuildNumber = prompt(text: 'Desired BUILD number:')

                        increment_build_number(
                            xcodeproj: '\(projectName).xcodeproj',
                            build_number: newBuildNumber
                        )

                        # === Sort all project entries

                        sh 'cd ./.. && xcodeproj sort "\(projectName).xcodeproj"'

                        # === Add custom 'Run Script Phase' entries
                    """
                    .asIndentedText(with: &indentation)

                indentation++

                if
                    usesSwiftGen
                {
                    result <<< swiftGenBuildPhase(
                        projectFileName: projectName
                        )
                        .asIndentedText(with: &indentation)
                }

                if
                    usesSourcery
                {
                    result <<< sourceryBuildPhase(
                        projectFileName: projectName
                        )
                        .asIndentedText(with: &indentation)
                }

                if
                    usesSwiftLint == .global
                {
                    result <<< swiftLintGlobalBuildPhase(
                        projectFileName: projectName
                        )
                        .asIndentedText(with: &indentation)
                }

                if
                    usesSwiftLint == .cocoaPods
                {
                    result <<< swiftLintCocoaPodsBuildPhase(
                        projectFileName: projectName
                        )
                        .asIndentedText(with: &indentation)
                }

                indentation--

                result <<< """

                    end
                    """
                    .asIndentedText(with: &indentation)

            case .archiveStaging(
                let projectName,
                let schemeName,
                let exportMethod,
                let productName,
                let archivesExportPath
                ):
                result <<< """

                    lane :archiveStaging do

                        ensure_git_status_clean

                        # === Set basic parameters

                        buildNumber = get_build_number(xcodeproj: '\(projectName).xcodeproj')
                        versionNumber = get_version_number(xcodeproj: '\(projectName).xcodeproj')

                        puts 'Attempt to use SCHEME: \(schemeName)'

                        # === Check if target version number is eligible for this line

                        # project must be on version number 'X.Y.Z-beta.*'

                        if (!(versionNumber.include? 'dirty') && (versionNumber.include? 'beta'))

                            # git status is clean at this point

                            # === main part

                            # seems to be allowed to run this lane

                            gym(
                                scheme: '\(schemeName)',
                                export_method: '\(exportMethod)',
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
                            puts 'NOTE: this lane is for STAGING (beta) builds ONLY.'

                        end

                    end
                    """
                    .asIndentedText(with: &indentation)
        }

        //---

        return result
    }
}

// MARK: - Helpers

fileprivate
extension Fastlane.Fastfile.Section
{

    func swiftGenBuildPhase(
        projectFileName: String
        ) -> String
    {
        // NOTE: depends on 'Xcodeproj' CL tool

        return """

            # === lets add SwiftGen build phase script to product target of given project

            # remember, we are in ./fastlane/ folder now...
            fullProjFilePath = Dir.pwd + '/../\(projectFileName).xcodeproj'

            project = Xcodeproj::Project.open(fullProjFilePath)

            project.targets.select { |t| t.name == '\(projectFileName)' }.each { |target|

                swiftLintPhase = target.new_shell_script_build_phase("SwiftGen")
                swiftLintPhase.shell_script = '"$PODS_ROOT/SwiftGen/bin/swiftgen" config run --config ".swiftgen.yml"'
                # swiftLintPhase.run_only_for_deployment_postprocessing = '1'

                target.build_phases.delete(swiftLintPhase)
                target.build_phases.unshift(swiftLintPhase)

            }

            project.save()
            """
    }

    func sourceryBuildPhase(
        projectFileName: String
        ) -> String
    {
        // NOTE: depends on 'Xcodeproj' CL tool

        return """

            # === lets add Sourcery build phase script to product target of given project

            # remember, we are in ./fastlane/ folder now...
            fullProjFilePath = Dir.pwd + '/../\(projectFileName).xcodeproj'

            project = Xcodeproj::Project.open(fullProjFilePath)

            project.targets.select { |t| t.name == '\(projectFileName)' }.each { |target|

                swiftLintPhase = target.new_shell_script_build_phase("Sourcery")
                swiftLintPhase.shell_script = '"$PODS_ROOT/Sourcery/bin/sourcery" --prune'
                # swiftLintPhase.run_only_for_deployment_postprocessing = '1'

                target.build_phases.delete(swiftLintPhase)
                target.build_phases.unshift(swiftLintPhase)

            }

            project.save()
            """
    }

    func swiftLintGlobalBuildPhase(
        projectFileName: String
        ) -> String
    {
        // NOTE: depends on 'Xcodeproj' CL tool

        return """

            # === lets add SwiftLint build phase script to each target of given project

            # remember, we are in ./fastlane/ folder now...
            fullProjFilePath = Dir.pwd + '/../\(projectFileName).xcodeproj'

            project = Xcodeproj::Project.open(fullProjFilePath)

            project.targets.each { |target|

                swiftLintPhase = target.new_shell_script_build_phase("SwiftLint")
                swiftLintPhase.shell_script = 'if which swiftlint >/dev/null; then
                    swiftlint
                else
                    echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
                fi'
                # swiftLintPhase.run_only_for_deployment_postprocessing = '1'

                target.build_phases.delete(swiftLintPhase)
                target.build_phases.unshift(swiftLintPhase)

            }

            project.save()
            """
    }

    func swiftLintCocoaPodsBuildPhase(
        projectFileName: String
        ) -> String
    {
        // NOTE: depends on 'Xcodeproj' CL tool

        return """

            # === lets add SwiftLint build phase script to each target of given project

            # remember, we are in ./fastlane/ folder now...
            fullProjFilePath = Dir.pwd + '/../\(projectFileName).xcodeproj'

            project = Xcodeproj::Project.open(fullProjFilePath)

            project.targets.each { |target|

                swiftLintPhase = target.new_shell_script_build_phase("SwiftLint")
                swiftLintPhase.shell_script = '"${PODS_ROOT}/SwiftLint/swiftlint"'
                # swiftLintPhase.run_only_for_deployment_postprocessing = '1'

                target.build_phases.delete(swiftLintPhase)
                target.build_phases.unshift(swiftLintPhase)

            }

            project.save()
            """
    }
}

fileprivate
func nothingUnless(
    _ condition: Bool,
    _ ifConditionSatisfied: String
    ) -> String
{
    return (condition ? ifConditionSatisfied : "")
}
