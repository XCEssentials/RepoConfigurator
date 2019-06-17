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

import PathKit

//---

public
extension CocoaPods
{
    final
    class Podfile: FixedNameTextFileAuto
    {
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
    func abstractTarget(
        _ targetName: String,
        includePodsFromPodspec: Bool = false,
        pods: [String],
        nestedTargets: (CocoaPods.Podfile.AbstractTargetContext) -> Void = { _ in }
        ) -> CocoaPods.Podfile
    {
        CocoaPods
            .Podfile
            .AbstractTargetContext(
                with: buffer
            )
            .abstractTarget(
                targetName,
                includePodsFromPodspec: includePodsFromPodspec,
                pods: pods,
                nestedTargets: nestedTargets
            )
        
        //---
        
        return self
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
        ) -> CocoaPods.Podfile
    {
        CocoaPods
            .Podfile
            .AbstractTargetContext(
                with: buffer
            )
            .target(
                targetName,
                projectName: projectName,
                deploymentTarget: deploymentTarget,
                usesSwift: usesSwift,
                includePodsFromPodspec: includePodsFromPodspec,
                pods: pods,
                tests: tests,
                otherEntries: otherEntries
            )

        //---

        return self
    }
    
    func postInstall(
        installerVar: String = "installer",
        _ body: (CocoaPods.Podfile.PostInstallContext) -> Void
        ) -> CocoaPods.Podfile
    {
        buffer <<< { """
            
            post_install do |\(installerVar)|
            
            """
        }()

        buffer.indentation.nest{

            body(
                .init(
                    buffer,
                    installerVar
                )
            )
        }
        
        buffer <<< { """
            
            end # post_install
            """
        }()
        
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
