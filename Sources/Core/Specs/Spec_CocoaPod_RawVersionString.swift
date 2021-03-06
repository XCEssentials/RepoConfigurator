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

import Version

//---

//internal
extension Spec.CocoaPod
{
    enum RawVersionString {}
}

// MARK: - ExtractFromPodspec

//internal
extension Spec.CocoaPod.RawVersionString
{
    enum ExtractFromPodspecError: Error
    {
        case specContentIsEmpty
        case noVersionEntryFound
        case unableToParseVersionEntry
        case invalidRawVersionString
    }
    
    static
    func extract(
        fromPodspec specContent: String
    )
        -> Result<String, ExtractFromPodspecError>
    {
        guard
            !specContent.isEmpty
        else
        {
            return .failure(.specContentIsEmpty)
        }
        
        //---
        
        enum Keyword: String
        {
            case version
        }
        
        guard
            let versionEntry = specContent
                .components(separatedBy: .newlines)
                .filter({ $0.lowercased().contains(Keyword.version.rawValue) })
                .first
        else
        {
            return .failure(.noVersionEntryFound)
        }
        
        //---
        
        guard
            let versionStringMaybe = versionEntry
                .components(separatedBy: .whitespaces)
                .last?
                .trimmingCharacters(in: .punctuationCharacters)
        else
        {
            return .failure(.unableToParseVersionEntry)
        }
        
        //---
        
        guard
            let result = Version
                .init(versionStringMaybe)?
                .description
        else
        {
            return .failure(.invalidRawVersionString)
        }
        
        //---
        
        return .success(result)
    }
}

// MARK: - ExtractFromBranch

//internal
extension Spec.CocoaPod.RawVersionString
{
    enum ExtractFromBranchError: Error
    {
        case branchNameIsEmpty
        case failedToParseVersionFromBranchName
        case invalidRawVersionString
    }
        
    static
    func extract(
        fromBranch branchName: String
    )
        -> Result<String, ExtractFromBranchError>
    {
        guard
            !branchName.isEmpty
        else
        {
            return .failure(.branchNameIsEmpty)
        }
        
        //---
        
        guard
            let versionStringMaybe = branchName
                .split(separator: "/")
                .last
        else
        {
            return .failure(.failedToParseVersionFromBranchName)
        }
        
        //---
        
        guard
            let result = Version
                .init(versionStringMaybe)?
                .description
        else
        {
            return .failure(.invalidRawVersionString)
        }
        
        //---

        return .success(result)
    }
}
