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
    final
    class Podfile: FixedNameTextFileAuto
    {
        // MARK: Type level members

        public
        struct UnitTestTargets
        {
            private
            let buffer: IndentedTextBuffer

            //internal
            init(
                with buffer: IndentedTextBuffer
                )
            {
                self.buffer = buffer
            }
        }

        public
        enum InheritanceMode: String
        {
            case nothing = "none"
            case searchPaths = "search_paths"
            case complete = "complete"
        }
        
        // MARK: Instance level members

        private
        var buffer: IndentedTextBuffer = .init()

        public
        var fileContent: IndentedText
        {
            return buffer.content
        }

        // MARK: Initializers

        public
        init(
            workspaceName: String? = nil
            )
        {
            buffer <<< workspaceName.map{ """
                workspace '\($0)'
                """
            }
        }
    }
}

// MARK: - Content rendering

public
extension CocoaPods.Podfile
{
    func target(
        _ targetName: String,
        projectName: String? = nil,
        deploymentTarget: DeploymentTarget,
        usesSwift: Bool = true, // adds 'use_frameworks!'
        includePodsFromPodspec: Bool = false,
        pods: [String],
        tests: (CocoaPods.Podfile.UnitTestTargets) -> Void = { _ in }
        ) -> CocoaPods.Podfile
    {
        buffer <<< """

            target '\(targetName)' do

            """

        buffer.indentation.nest{

            buffer <<< """
                project '\(projectName ?? targetName)'
                platform :\(deploymentTarget.platform.cocoaPodsId), '\(deploymentTarget.minimumVersion)'

                # Comment the next line if you're not using Swift
                # and don't want to use dynamic frameworks
                \(usesSwift ? "" : "# ")use_frameworks!

                """

            buffer <<< includePodsFromPodspec.mapIf(true){ """
                \(Defaults.podsFromSpec)

                """
            }

            buffer <<< pods.map{ """
                \($0)
                """
            }

            tests(
                UnitTestTargets(
                    with: buffer
                )
            )
        }

        // end target
        buffer <<< """

            end
            """

        //---

        return self
    }

    func custom(
        _ customEntry: String
        ) -> CocoaPods.Podfile
    {
        buffer <<< customEntry

        //---

        return self
    }
}

public
extension CocoaPods.Podfile.UnitTestTargets
{
    func unitTestTarget(
        _ name: String,
        inherit inheritanceMode: CocoaPods.Podfile.InheritanceMode? = .searchPaths,
        pods: [String]
        )
    {
        buffer <<< """

            target '\(name)' do

            """

        buffer.indentation.nest{

            buffer <<< inheritanceMode.map{ """
                inherit! :\($0.rawValue)

                """
            }

            buffer <<< pods.map{ """
                \($0)
                """
            }
        }

        buffer <<< """

            end
            """
    }
}
