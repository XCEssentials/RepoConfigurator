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
extension Xcode
{
    public
    typealias BinaryDependency = (
        location: String,
        codeSignOnCopy: Bool
    )
    
    public
    typealias ProjectDependency = (
        location: String,
        frameworks: [FrameworkDependency]
    )
    
    public
    typealias FrameworkDependency = (
        name: String,
        copy: Bool,
        codeSignOnCopy: Bool
    )
    
    //---
    
    public
    final
    class Dependencies
    {
        // MARK: Instance level members

        public private(set)
        var fromSDKs: [String] = []
        
        public
        func fromSDK(
            _ element: String...
            )
        {
            fromSDKs.append(contentsOf: element)
        }

        public private(set)
        var otherTargets: [String] = []
        
        public
        func otherTarget(
            _ element: String...
            )
        {
            otherTargets.append(contentsOf: element)
        }

        public private(set)
        var binaries: [BinaryDependency] = []
        
        public
        func binary(
            _ element: BinaryDependency...
            )
        {
            binaries.append(contentsOf: element)
        }
        
        public private(set)
        var projects: [ProjectDependency] = []
        
        public
        func project(
            _ element: ProjectDependency...
            )
        {
            projects.append(contentsOf: element)
        }

        // MARK: Initializers

        public
        init() {}
    }
}

// MARK: - Content rendering

extension Xcode.Dependencies: TextFilePiece
{
    public
    func asIndentedText(
        with indentation: Indentation
        ) -> IndentedText
    {
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#references

        //---

        guard
            !fromSDKs.isEmpty ||
            !otherTargets.isEmpty ||
            !binaries.isEmpty ||
            !projects.isEmpty
        else
        {
            return []
        }

        //---

        let result: IndentedTextBuffer = .init(with: indentation)

        //---

        result <<< """
            references:
            """

        result <<< fromSDKs.map{"""
            - sdkroot: \($0)
            """
        }

        result <<< otherTargets.map{"""
            - location: \($0)
            """
        }

        result <<< binaries.map{ """
            - location: \($0.location)
              codeSignOnCopy: \($0.codeSignOnCopy)
            """
        }

        result <<< projects.map{

            type(of: self).renderSingleProject($0, with: indentation)
        }

        //---

        return result.content
    }

    private
    static
    func renderSingleProject(
        _ project: Xcode.ProjectDependency,
        with indentation: Indentation
        ) -> IndentedText
    {
        let result: IndentedTextBuffer = .init(with: indentation)

        //---

        result <<< """
            - location: \(project.location)
              frameworks:
            """

        indentation.nest{

            result <<< project.frameworks.map{ """
                - name: \($0.name)
                  copy: \($0.copy)
                  codeSignOnCopy: \($0.codeSignOnCopy)
                """
            }
        }

        //---

        return result.content
    }
}
