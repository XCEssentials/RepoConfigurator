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
        var relativeLocation: Path
        {
            return Spec.Locations.fastlane + Fastfile.intrinsicFileName
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
        enum BuildPhaseScriptPosition
        {
            case preCompile
            case postCompile
        }
        
        public
        struct ScriptBuildPhaseContext
        {
            private
            let buffer: IndentedTextBuffer
            
            //internal
            init(
                _ buffer: IndentedTextBuffer
                )
            {
                self.buffer = buffer
            }
        }

        public
        struct BuildSettingsContext
        {
            private
            let buffer: IndentedTextBuffer
            
            //internal
            init(
                _ buffer: IndentedTextBuffer
                )
            {
                self.buffer = buffer
            }
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

public
extension Fastlane.Fastfile.ScriptBuildPhaseContext
{
    func custom(
        project: Path = Spec.Project.location,
        targetNames: [String],
        scriptName: String,
        scriptBody: String,
        runOnlyForDeploymentPostprocessing: Bool? = nil,
        position: Fastlane.Fastfile.BuildPhaseScriptPosition = .preCompile
        )
    {
        guard
            !targetNames.isEmpty
        else
        {
            return
        }

        //---

        let project: Path = (
            project.isAbsolute ?
                project
                : "./.." + project
        )
        
        let targetNames = targetNames
            .map{ "'\($0)'" }
            .joined(separator: ", ")

        //---

        buffer <<< {"""
            
            # === Build Phase Script - \(scriptName) | \(targetNames) | \(project)
            
            """
        }()
        
        buffer <<< {"""
            begin
            
                project = Xcodeproj::Project.open("\(project)")
            
            rescue => ex
            
                # https://github.com/fastlane/fastlane/issues/7944#issuecomment-274232674
                UI.error ex
                UI.error("Failed to add Build Phase Script - \(scriptName) | \(targetNames) | \(project)")
            
            end
            
            """
        }()
        
        buffer <<< {"""
            project
                .targets
                .select{ |t| [\(targetNames)].include?(t.name) }
                .each{ |t|

                    thePhase = t.shell_script_build_phases.find { |s| s.name == "\(scriptName)" }
            
                    unless thePhase.nil?
                        t.build_phases.delete(thePhase)
                    end
            
                    thePhase = t.new_shell_script_build_phase("\(scriptName)")
                    thePhase.shell_script = '\(scriptBody)'
                    \(runOnlyForDeploymentPostprocessing
                        .map{ "thePhase.run_only_for_deployment_postprocessing = '\(($0 ? 1 : 0))'" }
                        ?? "# thePhase.run_only_for_deployment_postprocessing = ..."
                    )
            
                    \(position == .preCompile ?
                        """
                        t.build_phases.unshift(t.build_phases.delete(thePhase)) # move to top
                        """
                        : "# NOTE: 'thePhase' will be placed after 'compile' phase"
                    )
            
            
                }

            project.save()
            
            UI.success("Added Build Phase Script - \(scriptName) | \(targetNames) | \(project)")
            """
        }()
    }
    
    func swiftGen(
        project: Path = Spec.Project.location,
        targetNames: [String],
        scriptName: String = "SwiftGen",
        params: [String] = []
        )
    {
        custom(
            project: project,
            targetNames: targetNames,
            scriptName: scriptName,
            scriptBody: """
                "$PODS_ROOT/SwiftGen/bin/swiftgen"  \(params.joined(separator: " "))
                """
        )
    }
    
    func sourcery(
        project: Path = Spec.Project.location,
        targetNames: [String],
        scriptName: String = "Sourcery",
        params: [String] = [
            "--prune"
            ]
        )
    {
        custom(
            project: project,
            targetNames: targetNames,
            scriptName: scriptName,
            scriptBody: """
                "$PODS_ROOT/Sourcery/bin/sourcery"  \(params.joined(separator: " "))
                """
        )
    }
    
    func swiftLint(
        project: Path = Spec.Project.location,
        targetNames: [String],
        scriptName: String = "SwiftLintPods",
        params: [String] = []
        )
    {
        custom(
            project: project,
            targetNames: targetNames,
            scriptName: scriptName,
            scriptBody: """
                "$PODS_ROOT/SwiftLint/swiftlint"  \(params.joined(separator: " "))
                """
        )
    }
}

public
extension Fastlane.Fastfile.BuildSettingsContext
{
    func projectLevel(
        project: Path = Spec.Project.location,
        shared: Xcode.RawBuildSettings = [:],
        perConfiguration: [Xcode.BuildConfiguration : Xcode.RawBuildSettings] = [:]
        )
    {
        let project: Path = (
            project.isAbsolute ?
                project
                : "./.." + project
        )
        
        //---
        
        buffer <<< {"""
            
            # === Build Settings | \(project)
            
            begin
            
                project = Xcodeproj::Project.open("\(project)")
            
            rescue => ex
            
                # https://github.com/fastlane/fastlane/issues/7944#issuecomment-274232674
                UI.error ex
                UI.error("Failed to set Build Settings - \(project)")
            
            end
            
            project.build_configurations.each do |config|
            
            """
        }()
        
        buffer.indentation.nest{
            
            buffer <<< shared
                .sortedByKey()
                .map{ "config.build_settings['\($0)'] = '\($1)'" }
            
            perConfiguration.forEach{
                
                (config, settings) in
                
                //---
                
                buffer <<< {"""
                    if config.name == "\(config.title)"
                    
                    """
                }()
                
                buffer.indentation.nest{
                    
                    buffer <<< settings
                        .sortedByKey()
                        .map{ "config.build_settings['\($0)'] = '\($1)'" }
                }
                
                buffer <<< {"""
                    
                    end # config.name == "\(config.title)"
                    """
                }()
            }
        }
        
        buffer <<< {"""
            
            end # project.build_configurations.each

            project.save()
            
            UI.success("Set Build Settings - \(project)")
            """
        }()
    }
    
    func targetLevel(
        project: Path = Spec.Project.location,
        target: String,
        shared: Xcode.RawBuildSettings = [:],
        perConfiguration: [Xcode.BuildConfiguration : Xcode.RawBuildSettings] = [:]
        )
    {
        let project: Path = (
                project.isAbsolute ?
                project
                : "./.." + project
            )
        
        //---
        
        buffer <<< {"""
            
            # === Build Settings | \(target) | \(project)
            
            begin
            
                project = Xcodeproj::Project.open("\(project)")
            
            rescue => ex
            
                # https://github.com/fastlane/fastlane/issues/7944#issuecomment-274232674
                UI.error ex
                UI.error("Failed to set Build Settings - \(target) | \(project)")
            
            end
            
            begin
            
                target = project.targets.find { |e| e.name == "\(target)" }
                raise RuntimeError, 'Target \(target) is not found' if target.nil?
            
            rescue => ex
            
                # https://github.com/fastlane/fastlane/issues/7944#issuecomment-274232674
                UI.error ex
                UI.error("Failed to set Build Settings - \(target) | \(project)")
            
            end
            
            target.build_configurations.each do |config|
            
            """
        }()
        
        buffer.indentation.nest{
            
            buffer <<< shared
                .sortedByKey()
                .map{ "config.build_settings['\($0)'] = '\($1)'" }
            
            perConfiguration.forEach{
                
                (config, settings) in
                
                //---
                
                buffer.appendNewLine()
                
                buffer <<< {"""
                    if config.name == "\(config.title)"
                    
                    """
                }()
                
                buffer.indentation.nest{
                    
                    buffer <<< settings
                        .sortedByKey()
                        .map{ "config.build_settings['\($0)'] = '\($1)'" }
                }
                
                buffer <<< {"""
                    
                    end # config.name == "\(config.title)"
                    """
                }()
            }
        }
        
        buffer <<< {"""
            
            end # target.build_configurations.each

            project.save()
            
            UI.success("Set Build Settings - \(target) | \(project)")
            """
        }()
    }
}
