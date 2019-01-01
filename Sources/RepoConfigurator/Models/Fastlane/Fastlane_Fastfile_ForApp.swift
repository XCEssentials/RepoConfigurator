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
    class ForApp: Fastlane.Fastfile {}
}

//---

public
extension Fastlane.Fastfile.ForApp
{
    func beforeRelease(
        beginningEntries: [String] = [],
        ensureGitBranch: String? = Defaults.releaseGitBranchesRegEx,
        project: Path = Spec.Project.location,
        masterPodSpec: Path = Spec.CocoaPod.podspecLocation,
        otherPodSpecs: [Path] = [],
        endingEntries: [String] = []
        ) -> Self
    {
        let laneName = #function.split(separator: "(").first!
        
        let project = Utils.mutate(project){
            
            $0.pathExtension = Xcode.Project.extension // just in case!
        }
        
        let masterPodSpec = Utils.mutate(masterPodSpec){
            
            $0.pathExtension = CocoaPods.Podspec.extension // just in case!
        }
        
        let otherPodSpecs = otherPodSpecs.map{
            
            Utils.mutate($0){
                
                $0.pathExtension = CocoaPods.Podspec.extension // just in case!
            }
            
        }
        
        let allPodspecs = [masterPodSpec] + otherPodSpecs
        
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

            main <<< { """
                
                ensure_git_status_clean
                """
            }()

            main <<< { """
                
                # === Read current version number

                versionNumber = version_get_podspec(
                    path: '\(masterPodSpec)'
                )
                
                puts 'Current VERSION number: ' + versionNumber
                
                # === Infer new version number

                defaultNewVersion = git_branch.split('/').last

                # === Define new version & build number

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
                
                newBuildNumber = number_of_commits

                # === Apply NEW version & build number

                increment_version_number(
                    xcodeproj: '\(project)',
                    version_number: newVersionNumber
                )

                increment_build_number(
                    xcodeproj: '\(project)',
                    build_number: newBuildNumber
                )
                
                """
            }()
            
            main <<< allPodspecs.map{ """
                
                version_bump_podspec(
                    path: '\($0)',
                    version_number: newVersionNumber
                )
                """
            }
            
            main <<< { """

                # ===

                commit_version_bump(
                    message: 'Version Bump to ' + newVersionNumber + ' (' + newBuildNumber + ')',
                    xcodeproj: '\(project)',
                    include: \(allPodspecs.map{ $0.rawValue })
                )
                """
            }()
            
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

    func reconfigureProject(
        beginningEntries: [String] = [],
        project: Path = Spec.Project.location,
        callGems: GemCallMethod = .viaBundler,
        scriptBuildPhases: (ScriptBuildPhaseContext) -> Void = { _ in },
        buildSettings: (BuildSettingsContext) -> Void = { _ in },
        endingEntries: [String] = []
        ) -> Self
    {
        let laneName = #function.split(separator: "(").first!
        
        let project = Utils.mutate(project){
            
            $0.pathExtension = Xcode.Project.extension // just in case!
        }
        
        //---

        _ = require(
            CocoaPods.gemName,
            Xcodeproj.gemName
        )
        
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
            
            main <<< { """
                
                # === Re-integrate dependencies

                # default initial location for any command
                # is inside 'Fastlane' folder

                sh 'cd ./.. && \(CocoaPods.call(callGems)) install'

                # === Sort all project entries

                # default initial location for any command
                # is inside 'Fastlane' folder

                sh 'cd ./.. && \(Xcodeproj.call(callGems)) sort "\(project)"'
                """
            }()

            scriptBuildPhases(
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

    func archiveBeta(
        productName: String,
        project: Path = Spec.Project.location,
        schemeName: String? = nil, // 'productName' will be used if 'nil'
        exportMethod: Fastlane.Fastfile.ArchiveExportMethod = Defaults.stagingExportMethod,
        archivesExportLocation: Path = Defaults.archivesExportLocation
        ) -> Self
    {
        let laneName = #function.split(separator: "(").first!
        
        let project = Utils.mutate(project){
            
            $0.pathExtension = Xcode.Project.extension // just in case!
        }
        
        let schemeName = schemeName ?? productName

        //---

        //swiftlint:disable line_length

        main <<< """

            lane :\(laneName) do

                ensure_git_status_clean

                # === Set basic parameters

                buildNumber = get_build_number(
                    xcodeproj: '\(project)'
                )

                versionNumber = get_version_number(
                    xcodeproj: '\(project)'
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
                        export_method: '\(exportMethod)',
                        output_name: '\(productName)_' + versionNumber + '_' + buildNumber + '.ipa',
                        output_directory: '\(archivesExportLocation.rawValue)'
                    )

                    # === mark dirty

                    # puts 'NOTE: Mark project version as dirty now.'

                    newVersionNumber = versionNumber + '+dirty'

                    increment_version_number(
                        xcodeproj: '\(project)',
                        version_number: newVersionNumber
                    )

                    # only set 'dirty' mark in 'versionNumber'!

                    commit_version_bump(
                        xcodeproj: '\(project)',
                        message: 'Version Bump to ' + newVersionNumber + ' (' + buildNumber + ')'
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
