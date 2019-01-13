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

public
extension Fastlane.Fastfile
{
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
}

// MARK: - Content rendering

public
extension Fastlane.Fastfile.ScriptBuildPhaseContext
{
    enum BuildPhaseScriptPosition
    {
        case preCompile
        case postCompile
    }
    
    func custom(
        project: Path = Spec.Project.location,
        targetNames: [String],
        scriptName: String,
        scriptBody: String,
        runOnlyForDeploymentPostprocessing: Bool? = nil,
        position: BuildPhaseScriptPosition = .preCompile
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
