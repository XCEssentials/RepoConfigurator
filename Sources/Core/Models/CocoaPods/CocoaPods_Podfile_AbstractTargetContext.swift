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
extension CocoaPods.Podfile
{
    struct AbstractTargetContext
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
}

// MARK: - Content rendering

public
extension CocoaPods.Podfile.AbstractTargetContext
{
    func abstractTarget(
        _ targetName: String,
        includePodsFromPodspec: Bool = false,
        pods: [String],
        nestedTargets: (CocoaPods.Podfile.AbstractTargetContext) -> Void = { _ in }
        )
    {
        buffer <<< """

            abstract_target '\(targetName)' do

            """

        buffer.indentation.nest{

            buffer <<< includePodsFromPodspec.mapIf(true){ """
                \(Defaults.podsFromSpec)

                """
            }

            buffer <<< pods.map{ """
                \($0)
                """
            }

            nestedTargets(
                CocoaPods.Podfile.AbstractTargetContext(
                    with: buffer
                )
            )
        }

        // end target
        buffer <<< """

            end
            """
    }
    
    func target(
        _ targetName: String,
        projectName: String? = nil,
        deploymentTarget: DeploymentTarget,
        usesSwift: Bool = true, // adds 'use_frameworks!'
        includePodsFromPodspec: Bool = false,
        pods: [String],
        tests: (CocoaPods.Podfile.ConcreteTargetContext) -> Void = { _ in },
        otherEntries: [String] = []
        )
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
                CocoaPods.Podfile.ConcreteTargetContext(
                    with: buffer
                )
            )
            
            otherEntries.isEmpty ? () : buffer.appendNewLine()
            
            buffer <<< otherEntries
        }

        // end target
        buffer <<< """

            end
            """
    }
}
