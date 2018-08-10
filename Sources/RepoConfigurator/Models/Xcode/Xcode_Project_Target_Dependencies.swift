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
extension Xcode.Project.Target
{
    public
    typealias BinaryDependency = (
        location: String,
        codeSignOnCopy: Bool
    )
    
    public
    typealias ProjectDependencies = (
        location: String,
        frameworks: [ProjectDependency]
    )
    
    public
    typealias ProjectDependency = (
        name: String,
        copy: Bool,
        codeSignOnCopy: Bool
    )
    
    //---
    
    public
    struct Dependencies
    {
        public private(set)
        var fromSDKs: [String] = []
        
        public
        mutating
        func fromSDK(
            _ element: String...
            )
        {
            fromSDKs.append(contentsOf: element)
        }
        
        //---
        
        public private(set)
        var otherTargets: [String] = []
        
        public
        mutating
        func otherTarget(
            _ element: String...
            )
        {
            otherTargets.append(contentsOf: element)
        }
        
        //---
        
        public private(set)
        var binaries: [BinaryDependency] = []
        
        public
        mutating
        func binary(
            _ element: BinaryDependency...
            )
        {
            binaries.append(contentsOf: element)
        }
        
        //---
        
        public private(set)
        var projects: [ProjectDependencies] = []
        
        public
        mutating
        func project(
            _ element: ProjectDependencies...
            )
        {
            projects.append(contentsOf: element)
        }
        
        //---
        
        // internal
        init()
        {
            //
        }
    }
}
