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
extension CocoaPods
{
    public
    struct Podfile: FixedNameTextFile
    {
        // MARK: - Type level members

        public
        static
        let fileName = "Podfile"

        // MARK: - Instance level members

        public private(set)
        var fileContent: [IndentedTextGetter] = []

        // MARK: - Initializers

        public
        init(
            workspaceName: String,
            targets: [Target],
            otherGlobalEntries: [String] = []
            )
        {
            fileContent <<< [

                "workspace '\(workspaceName)'",
                targets,
                otherGlobalEntries.map{ "\n\($0)" }.asMultiLine
            ]
        }

        public
        init(
            workspaceName: String,
            targets: [Target]
            )
        {
            self.init(
                workspaceName: workspaceName,
                targets: targets,
                otherGlobalEntries: []
            )
        }
    }
}

public
extension CocoaPods.Podfile
{
    public
    struct Target
    {
        // MARK: - Instance level members

        public
        let targetName: String

        public
        let projectName: String

        public
        let deploymentTarget: DeploymentTarget

        public
        let usesSwift: Bool // adds 'use_frameworks!

        public
        let includePodsFromPodspec: Bool

        public
        let pods: [String]

        public
        let tests: [UnitTestTarget]

        // MARK: - Initializers

        public
        init(
            targetName: String,
            projectName: String? = nil,
            deploymentTarget: DeploymentTarget,
            usesSwift: Bool = true, // adds 'use_frameworks!'
            includePodsFromPodspec: Bool = false,
            pods: [String],
            tests: UnitTestTarget...
            )
        {
            self.targetName = targetName
            self.projectName = projectName ?? targetName
            self.deploymentTarget = deploymentTarget
            self.usesSwift = usesSwift
            self.includePodsFromPodspec = includePodsFromPodspec
            self.pods = pods
            self.tests = tests
        }
    }
}

public
extension CocoaPods.Podfile
{
    public
    struct UnitTestTarget
    {
        // MARK: - Type level members

        public
        enum InheritanceMode: String
        {
            case nothing = ":none"
            case searchPaths = ":search_paths"
            case complete = ":complete"
        }

        // MARK: - Instance level members

        public
        let name: String

        public
        let inheritanceMode: InheritanceMode?

        public
        let pods: [String]

        // MARK: - Initializers

        public
        init(
            _ name: String,
            inherit: InheritanceMode? = .searchPaths,
            _ pods: String...
            )
        {
            self.name = name
            self.inheritanceMode = inherit
            self.pods = pods
        }
    }
}

// MARK: - Content rendering

extension CocoaPods.Podfile.Target: TextFilePiece
{
    public
    func asIndentedText(
        with indentation: Indentation
        ) -> IndentedText
    {
        let result: IndentedTextBuffer = .init(with: indentation)

        //---

        result <<< """

            target '\(targetName)' do

            """

        indentation.nest{

            result <<< """
                project '\(projectName)'
                platform :\(deploymentTarget.platform.cocoaPodsId), '\(deploymentTarget.minimumVersion)'

                # Comment the next line if you're not using Swift
                # and don't want to use dynamic frameworks
                \(usesSwift ? "" : "# ")use_frameworks!

                """

            result <<< includePodsFromPodspec.mapIf(true){ """
                \(Defaults.podsFromSpec)

                """
            }

            result <<< pods.map{ """
                \($0)
                """
            }

            result <<< tests.map{

                $0.asIndentedText(with: indentation)
            }
        }

        // end target
        result <<< """

            end
            """

        //---

        return result.content
    }
}

extension CocoaPods.Podfile.UnitTestTarget: TextFilePiece
{
    public
    func asIndentedText(
        with indentation: Indentation
        ) -> IndentedText
    {
        let result: IndentedTextBuffer = .init(with: indentation)

        //---

        result <<< """

            target '\(name)' do

            """

        indentation.nest{

            result <<< inheritanceMode.map{ """
                inherit! \($0.rawValue)

                """
            }

            result <<< pods.map{ """
                \($0)
                """
            }
        }

        result <<< """

            end
            """

        //---

        return result.content
    }
}
