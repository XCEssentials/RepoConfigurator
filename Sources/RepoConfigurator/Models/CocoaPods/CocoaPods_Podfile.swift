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
    struct Podfile: FixedNameTextFile, ConfigurableTextFile
    {
        // MARK: - Type level members

        public
        static
        let fileName = "Podfile"

        public
        enum InheritanceMode: String
        {
            case nothing = ":none"
            case searchPaths = ":search_paths"
            case complete = ":complete"
        }

        public
        struct UnitTestTarget
        {
            // MARK: - Instance level members

            public
            let name: String

            public
            let inherit: InheritanceMode?

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
                self.inherit = inherit
                self.pods = pods
            }
        }

        public
        enum Section: TextFilePiece
        {
            case header(
                workspaceName: String
            )

            case target(
                targetName: String,
                projectName: String,
                deploymentTarget: DeploymentTarget,
                usesSwift: Bool, // adds 'use_frameworks!'
                pods: [String],
                tests: [UnitTestTarget]
            )

            case custom(
                String
            )
        }

        // MARK: - Instance level members

        public
        var fileContent: [IndentedTextGetter] = []
    }
}

// MARK: - Presets

public
extension CocoaPods.Podfile
{
    public
    static
    func standard(
        productName: String,
        targetName: String? = nil,
        projectName: String? = nil,
        deploymentTarget: DeploymentTarget,
        usesSwift: Bool = true,
        pods: [String],
        tests: [UnitTestTarget] = [],
        otherGlobalEntries: [String] = []
        ) -> CocoaPods.Podfile
    {
        return self
            .init()
            .extend(
                .header(
                    workspaceName: productName
                ),

                .target(
                    targetName: targetName ?? productName,
                    projectName: projectName ?? productName,
                    deploymentTarget: deploymentTarget,
                    usesSwift: usesSwift,
                    pods: pods,
                    tests: tests
                )
            )
            .extend(
                with: otherGlobalEntries.map{ .custom($0) }
            )
    }
}

// MARK: - Content rendering

public
extension CocoaPods.Podfile.Section
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
        case .header(
            let workspaceName
            ):
            result <<< """
                workspace '\(workspaceName)'
                """
                .asIndentedText(with: &indentation)

        case .target(
            let targetName,
            let projectName,
            let deploymentTarget,
            let usesSwift,
            let pods,
            let tests
            ):
            result <<< """

                target '\(targetName)' do

                    project '\(projectName)'
                    platform :\(deploymentTarget.platform.cocoaPodsId), '\(deploymentTarget.minimumVersion)'

                    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
                    \(usesSwift ? "" : "# ")use_frameworks!

                """
                .asIndentedText(with: &indentation)

            indentation++

            pods.forEach{

                result <<< """
                    \($0)
                    """
                        .asIndentedText(with: &indentation)
            }

            tests.forEach{

                result <<< """

                    target '\($0.name)' do

                    """
                    .asIndentedText(with: &indentation)

                indentation++

                $0.inherit.map{

                    result <<< """
                        inherit! \($0.rawValue)

                        """
                        .asIndentedText(with: &indentation)
                }

                $0.pods.forEach{

                    result <<< """
                        \($0)
                        """
                        .asIndentedText(with: &indentation)
                }

                indentation--

                result <<< """

                    end
                    """
                    .asIndentedText(with: &indentation)

            } // tests.forEach

            indentation--

            // end target
            result <<< """

                end
                """
                .asIndentedText(with: &indentation)

        case .custom(
            let customEntry
            ):
            result <<< """

                \(customEntry)
                """
                .asIndentedText(with: &indentation)
        }

        //---

        return result
    }
}
