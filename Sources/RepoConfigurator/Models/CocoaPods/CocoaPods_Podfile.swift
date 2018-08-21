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
        enum Target {}

        public
        enum UnitTestTarget {}

        public
        enum InheritanceMode: String
        {
            case nothing = "none"
            case searchPaths = "search_paths"
            case complete = "complete"
        }
        
        // MARK: - Instance level members

        public
        let fileContent: IndentedText

        // MARK: - Initializers

        public
        init(
            workspaceName: String,
            targets: [TextFileSection<Target>],
            otherGlobalEntries: [String] = []
            )
        {
            let result = IndentedTextBuffer()

            //---

            result <<< """
                workspace '\(workspaceName)'
                """

            result <<< targets

            result <<< otherGlobalEntries

            //---

            fileContent = result.content
        }
    }
}

// MARK: - Content rendering

public
extension TextFileSection
    where
    Context == CocoaPods.Podfile.Target
{
    static
    func target(
        targetName: String,
        projectName: String? = nil,
        deploymentTarget: DeploymentTarget,
        usesSwift: Bool = true, // adds 'use_frameworks!'
        includePodsFromPodspec: Bool = false,
        pods: [String],
        tests: TextFileSection<CocoaPods.Podfile.UnitTestTarget>...
        ) -> TextFileSection<Context>
    {
        return .init{

            indentation in

            //---

            let result: IndentedTextBuffer = .init(with: indentation)

            //---

            result <<< """

                target '\(targetName)' do

                """

            indentation.nest{

                result <<< """
                    project '\(projectName ?? targetName)'
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

                    $0.contentGetter(indentation)
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
}

public
extension TextFileSection
    where
    Context == CocoaPods.Podfile.UnitTestTarget
{
    static
    func unitTestTarget(
        _ name: String,
        inherit inheritanceMode: CocoaPods.Podfile.InheritanceMode? = .searchPaths,
        _ pods: String...
        ) -> TextFileSection<Context>
    {
        return .init{

            indentation in

            //---

            let result: IndentedTextBuffer = .init(with: indentation)

            //---

            result <<< """

                target '\(name)' do

                """

            indentation.nest{

                result <<< inheritanceMode.map{ """
                    inherit! :\($0.rawValue)

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
}
