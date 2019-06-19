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
extension CocoaPods.Podspec
{
    struct PerPlatformSettingsContext
    {
        private
        let specVar: String
        
        private
        let buffer: IndentedTextBuffer
        
        //internal
        init(
            specVar: String,
            buffer: IndentedTextBuffer
            )
        {
            self.specVar = specVar
            self.buffer = buffer
        }
    }
}

// MARK: - Content rendering

public
extension CocoaPods.Podspec.PerPlatformSettingsContext
{
    enum PrefixedEntry
    {
        case noPrefix(String)
        case sourceFiles(String)
        case dependency(String)
        
        fileprivate
        var unwrapped: String
        {
            switch self
            {
            case .noPrefix(let entry):
                return entry
                
            case .sourceFiles(let entry):
                return "source_files = '" + entry + "'"
                
            case .dependency(let entry):
                return "dependency '" + entry + "'"
            }
        }
    }
    
    /**
     Adds minimum deployment target declaration & related platform specific settings.
     */
    func settings(
        for deploymentTarget: DeploymentTarget,
        _ settigns: [PrefixedEntry]
        )
    {
        // https://guides.cocoapods.org/syntax/podspec.html#group_multi_platform_support

        let platformId = deploymentTarget.platform.cocoaPodsId
        let prefix = "\(specVar).\(platformId)."

        buffer.appendNewLine()
        
        buffer <<< """
            # === \(platformId)

            """

        buffer <<< """
            \(prefix)deployment_target = '\(deploymentTarget.minimumVersion)'

            """

        // might be a list of single lines,
        // one nultiline strings,
        // or a combination of single and multilines,
        // so lets flatten this out
        buffer <<< settigns.map{ """
            \(prefix)\($0.unwrapped)
            """
        }
    }
    
    /**
     Adds minimum deployment target declaration & related platform specific settings.
     */
    func settings(
        for deploymentTarget: DeploymentTarget,
        _ settigns: PrefixedEntry...
        )
    {
        settings(
            for: deploymentTarget,
            settigns
        )
    }
    
    /**
     Adds platform specific settings for given platform.
     */
    func settings(
        for platformId: OSIdentifier,
        _ settigns: [PrefixedEntry]
        )
    {
        // https://guides.cocoapods.org/syntax/podspec.html#group_multi_platform_support

        let platformId = platformId.cocoaPodsId
        let prefix = "\(specVar).\(platformId)."

        buffer.appendNewLine()
        
        buffer <<< """
            # === \(platformId)

            """

        // might be a list of single lines,
        // one nultiline strings,
        // or a combination of single and multilines,
        // so lets flatten this out
        buffer <<< settigns.map{ """
            \(prefix)\($0.unwrapped)
            """
        }
    }
    
    /**
     Adds platform specific settings for given platform.
     */
    func settings(
        for platformId: OSIdentifier,
        _ settigns: PrefixedEntry...
        )
    {
        settings(
            for: platformId,
            settigns
        )
    }
    
    /**
     Settings common for all platforms.
     */
    func settings(
        _ settigns: [PrefixedEntry]
        )
    {
        // https://guides.cocoapods.org/syntax/podspec.html#group_multi_platform_support

        let prefix = "\(specVar)."

        buffer.appendNewLine()
        
        // might be a list of single lines,
        // one nultiline strings,
        // or a combination of single and multilines,
        // so lets flatten this out
        buffer <<< settigns.map{ """
            \(prefix)\($0.unwrapped)
            """
        }
    }
    
    /**
     Settings common for all platforms.
     */
    func settings(
        _ settigns: PrefixedEntry...
        )
    {
        settings(
            settigns
        )
    }
}
