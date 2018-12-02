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

import FileKit

//---

extension Fastlane
{
    public
    class Fastfile: FixedNameTextFile
    {
        // MARK: Type level members
        
        public
        static
        var fileName: String
        {
            return (Spec.Locations.fastlane + Fastfile.intrinsicFileName).rawValue
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

        // MARK: Instance level members

        //internal
        var header: IndentedTextBuffer = .init()
        
        private
        var requiredGems: Set<String> = []
        
        private
        let enableRequiredGems: Bool

        //internal
        var main: IndentedTextBuffer = .init()

        public
        var fileContent: IndentedText
        {
            return header.content
                + (enableRequiredGems ? requiredGems.sorted().asIndentedText(with: .init()) : [])
                + main.content
        }

        // MARK: Initializers

        public
        init(
            enableRequiredGems: Bool = false // does not work properly yet
            )
        {
            self.enableRequiredGems = enableRequiredGems
        }
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
        ) -> Self
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
        ) -> Self
    {
        gems.joined(separator: "\n")
            .split(separator: "\n")
            .map{ "fastlane_require '\($0)'" }
            .forEach{ requiredGems.insert($0) }
     
        //---
        
        return self
    }
    
    func add(
        _ customEntry: String
        ) -> Self
    {
        main <<< customEntry

        //---

        return self
    }
    
    func lane(
        _ laneName: String,
        body: () -> String
        ) -> Self
    {
        main <<< """

            lane :\(laneName) do
            """
        
        main.appendNewLine()

        main.indentation.nest{

            main <<< body()
        }

        main <<< """

            end # lane :\(laneName)
            """

        //---
        
        return self
    }
}

// MARK: - Internal helpers

public
extension Fastlane.Fastfile
{
    enum ExtraScriptBuildPhase
    {
        case swiftGen(
            projectName: String,
            targetNames: [String]
        )
        
        case sourcery(
            projectName: String,
            targetNames: [String]
        )
        
        case swiftLint(
            projectName: String,
            targetNames: [String],
            params: [String]
        )
    }
}

// internal
extension Fastlane.Fastfile
{
    func processExtraScriptBuildPhases(
        _ config: [ExtraScriptBuildPhase]
        )
    {
        for item in config
        {
            switch item
            {
            case .swiftGen(let projectName, let targetNames):
                swiftGenBuildPhase(
                    projectName: projectName,
                    targetNames: targetNames
                )
                
            case .sourcery(let projectName, let targetNames):
                sourceryBuildPhase(
                    projectName: projectName,
                    targetNames: targetNames
                )
                
            case .swiftLint(let projectName, let targetNames, let params):
                swiftLintBuildPhase(
                    projectName: projectName,
                    targetNames: targetNames,
                    params: params
                )
            }
        }
    }
    
    func swiftGenBuildPhase(
        projectName: String,
        targetNames: [String]
        )
    {
        guard
            !targetNames.isEmpty
        else
        {
            return
        }

        //---

        let scriptName = "SwiftGen"
        let targetNames = targetNames.map{ "'\($0)'" }.joined(separator: ", ")

        //---

        main.appendNewLine()
        
        main <<< """
            # === Add BUILD PHASE script '\(scriptName)'
            """
        
        main.appendNewLine()
        
        main <<< """
            # remember, we are in ./fastlane/ folder now...
            fullProjFilePath = Dir.pwd + '/../\(projectName).xcodeproj'
            """

        main.appendNewLine()
        
        main <<< """
            # https://github.com/fastlane/fastlane/issues/7944#issuecomment-274232674
            begin
                project = Xcodeproj::Project.open(fullProjFilePath)
            rescue => ex
                UI.error ex
                UI.user_error!("Failed to open project: " + fullProjFilePath)
            end
            """
        
        main.appendNewLine()
        
        main <<< """
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
    }

    func sourceryBuildPhase(
        projectName: String,
        targetNames: [String]
        )
    {
        guard
            !targetNames.isEmpty
        else
        {
            return
        }

        //---

        let scriptName = "Sourcery"
        let targetNames = targetNames.map{ "'\($0)'" }.joined(separator: ", ")

        //---

        main.appendNewLine()
        
        main <<< """
            # === Add BUILD PHASE script '\(scriptName)'
            """
        
        main.appendNewLine()
        
        main <<< """
            # remember, we are in ./fastlane/ folder now...
            fullProjFilePath = Dir.pwd + '/../\(projectName).xcodeproj'
            """
        
        main.appendNewLine()
        
        main <<< """
            # https://github.com/fastlane/fastlane/issues/7944#issuecomment-274232674
            begin
                project = Xcodeproj::Project.open(fullProjFilePath)
            rescue => ex
                UI.error ex
                UI.user_error!("Failed to open project: " + fullProjFilePath)
            end
            """
        
        main.appendNewLine()
        
        main <<< """
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
    }

    func swiftLintBuildPhase(
        projectName: String,
        targetNames: [String],
        params: [String]
        )
    {
        guard
            !targetNames.isEmpty
        else
        {
            return
        }

        //---

        let scriptName = "SwiftLintPods"
        let targetNames = targetNames.map{ "'\($0)'" }.joined(separator: ", ")

        //---

        main.appendNewLine()
        
        main <<< """
            # === Add BUILD PHASE script '\(scriptName)'
            """
        
        main.appendNewLine()
        
        main <<< """
            # remember, we are in ./fastlane/ folder now...
            fullProjFilePath = Dir.pwd + '/../\(projectName).xcodeproj'
            """

        main.appendNewLine()
        
        main <<< """
            # https://github.com/fastlane/fastlane/issues/7944#issuecomment-274232674
            begin
                project = Xcodeproj::Project.open(fullProjFilePath)
            rescue => ex
                UI.error ex
                UI.user_error!("Failed to open project: " + fullProjFilePath)
            end
            """
        
        main.appendNewLine()
        
        let theScript = """
            "${PODS_ROOT}/SwiftLint/swiftlint" \(params.joined(separator: " "))
            """
        
        main <<< """
            project
                .targets
                .select{ |t| [\(targetNames)].include?(t.name) }
                .each{ |t|

                    thePhase = t.new_shell_script_build_phase('\(scriptName)')
                    thePhase.shell_script = '\(theScript)'
                    # thePhase.run_only_for_deployment_postprocessing = '1'

                    t.build_phases.delete(thePhase)
                    t.build_phases.unshift(thePhase)

                }

            project.save()
            """
    }
}
