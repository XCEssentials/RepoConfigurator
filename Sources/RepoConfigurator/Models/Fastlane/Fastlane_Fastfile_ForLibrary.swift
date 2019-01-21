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
    public
    final
    class ForLibrary: Fastlane.Fastfile {}
}

//---

public
extension Fastlane.Fastfile.ForLibrary
{
    public
    enum PodspecLocation
    {
        case from(Spec.CocoaPod)
        case use(Path)
    }
    
    func beforeRelease(
        beginningEntries: [String] = [],
        ensureGitBranch: String? = Defaults.releaseGitBranchesRegEx,
        podspecLocation: PodspecLocation?, // pass 'nil' if shouldn't support CocoaPods
        endingEntries: [String] = []
        ) -> Self
    {
        let laneName = #function.split(separator: "(").first!

        let podSpec: Path?
        
        switch podspecLocation
        {
        case .some(.from(let cocoaPod)):
            podSpec = cocoaPod.podspecLocation
            
        case .some(.use(let value)):
            podSpec = value
            
        default:
            podSpec = nil
        }
        
        //---

        main <<< """

            lane :\(laneName) do
            """

        main.indentation.nest{

            main <<< beginningEntries
            
            main <<< beginningEntries.isEmpty.mapIf(false){ """
                
                # ===
                """
            }
            
            main <<< ensureGitBranch.map{ """

                ensure_git_branch(
                    branch: '\($0)'
                )
                """
            }

            main <<< """

                ensure_git_status_clean
                """

            main <<< (podSpec != nil).mapIf(true){ """

                # ===

                pod_lib_lint(
                    allow_warnings: true,
                    quick: true
                )
                """
            }

            main <<< podSpec.map{ """

                # === Remember current version number

                versionNumber = version_get_podspec(
                    path: '\($0)'
                )
                
                puts 'Current VERSION number: ' + versionNumber
                """
            }

            main <<< """

                # === Infer new version number

                newVersionNumber = git_branch.split('/').last

                puts 'New VERSION number: ' + newVersionNumber
                """

            main <<< podSpec.map{ """

                # === Bump version number & commit changes

                version_bump_podspec(
                    path: '\($0)',
                    version_number: newVersionNumber
                )
                
                git_commit(
                    path: '\($0)',
                    message: 'Version Bump to ' + newVersionNumber + ' in Podspec file'
                )
                """
            }
            
            main <<< endingEntries.isEmpty.mapIf(false){ """
                
                # ===
                
                """
            }
            
            main <<< endingEntries
        }

        main <<< """

            end # lane :\(laneName)
            """

        //---

        return self
    }
    
    /**
     Adds lane that generates Xcode development artifacts inside a given
     folder, using 'cocoapods' and 'cocoapods-generate'.
     */
    func generateProjectViaCP(
        beginningEntries: [String] = [],
        callCocoaPods: GemCallMethod, // enforce explicit configuration!
        prefixLocation: Path = ["Xcode"],
        extraGenParams: [String] = [],
        scriptBuildPhases: (ScriptBuildPhaseContext) throws -> Void = { _ in },
        buildSettings: (BuildSettingsContext) -> Void = { _ in },
        endingEntries: [String] = []
        ) rethrows -> Self
    {
        let laneName = #function.split(separator: "(").first!

        //---

        _ = require(
            CocoaPods.gemName,
            CocoaPods.Generate.gemName,
            Xcodeproj.gemName
        )
        
        //---

        main <<< """

            lane :\(laneName) do
            """
        
        main.appendNewLine()

        try main.indentation.nest{

            main <<< beginningEntries
            
            main.appendNewLine()

            let cleanupCmd = """
                rm -rf "\(prefixLocation)"
                """
            
            let genParams = (extraGenParams + [
                
                    """
                    --gen-directory="\(prefixLocation)"
                    """
                ])
                .joined(separator: " ")
            
            main <<< """
                # === Regenerate project
                
                # default initial location for any command
                # is inside 'Fastlane' folder

                sh 'cd ./.. && \(cleanupCmd) && \(CocoaPods.call(callCocoaPods)) \(CocoaPods.Generate.gemCallName) \(genParams)'
                """
            
            try scriptBuildPhases(
                .init(
                    main
                )
            )
            
            buildSettings(
                .init(
                    main
                )
            )
            
            main <<< endingEntries.isEmpty.mapIf(false){ """
                
                # ===
                
                """
            }
            
            main <<< endingEntries
        }

        main <<< """

            end # lane :\(laneName)
            """

        //---

        return self
    }
    
    /**
     Depends on SwiftPM and Ice.
     https://github.com/jakeheis/Ice
     */
    func generateProjectViaSwiftPM(
        derivedPaths: [Path] = [[".build"]],
        derivedProject: Spec.Project? = nil
        ) -> Self
    {
        let laneName = #function.split(separator: "(").first!

        var derivedPaths = derivedPaths
            
        derivedProject.map{
            
            derivedPaths += [$0.location]
        }
        
        //---
        
        main <<< """

            lane :\(laneName) do
            """

        main.indentation.nest{

            let cleanupCmd = derivedPaths
                .map{ """
                    rm -rf "\($0.rawValue)"
                    """
                }
                .joined(separator: " && ")
            
            main <<< """

                # === Regenerate project
                
                # default initial location for any command
                # is inside 'Fastlane' folder

                sh 'cd ./.. && \(cleanupCmd) && swift package generate-xcodeproj'
                """
        }

        main <<< """

            end # lane :\(laneName)
            """

        //---

        return self
    }
}
