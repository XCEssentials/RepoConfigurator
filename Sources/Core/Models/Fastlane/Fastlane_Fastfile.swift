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

extension Fastlane
{
    public
    class Fastfile: FixedNameTextFile
    {
        // MARK: Type level members
        
        public
        static
        var relativeLocation: Path
        {
            return Spec.Locations.fastlane + Fastfile.intrinsicFileName
        }
        
        // MARK: Instance level members

        //internal
        var header: IndentedTextBuffer = .init()
        
        private
        var requiredGems: Set<String> = []
        
        private
        let enableRequiredGems: Bool

        //internal
        var main: IndentedTextBuffer = .init()

        public
        var fileContent: IndentedText
        {
            return header.content
                + (enableRequiredGems ? requiredGems.sorted().asIndentedText(with: .init()) : [])
                + main.content
        }

        // MARK: Initializers

        public
        init(
            enableRequiredGems: Bool = false // does not work properly yet
            )
        {
            self.enableRequiredGems = enableRequiredGems
        }
    }
}

// MARK: - Content rendering

public
extension Fastlane.Fastfile
{
    func defaultHeader(
        optOutUsage: Bool = false,
        autoUpdateFastlane: Bool = false,
        minimumFastlaneVersion: VersionString = Defaults.minimumFastlaneVersion
        ) -> Self
    {
        //swiftlint:disable line_length

        header <<< """
            # Customise this file, documentation can be found here:
            # https://github.com/KrauseFx/fastlane/tree/master/docs
            # All available actions: https://github.com/KrauseFx/fastlane/blob/master/docs/Actions.md
            # can also be listed using the `fastlane actions` command

            # Change the syntax highlighting to Ruby
            # All lines starting with a # are ignored when running `fastlane`

            # More information about multiple platforms in fastlane: https://github.com/KrauseFx/fastlane/blob/master/docs/Platforms.md
            # All available actions: https://github.com/KrauseFx/fastlane/blob/master/docs/Actions.md

            # By default, fastlane will send which actions are used
            # No personal data is shared, more information on https://github.com/fastlane/enhancer
            # Uncomment the following line to opt out
            \(optOutUsage ? "" : "# ")opt_out_usage

            # If you want to automatically update fastlane if a new version is available:
            \(autoUpdateFastlane ? "" : "# ")update_fastlane

            # This is the minimum version number required.
            # Update this, if you use features of a newer version
            fastlane_version '\(minimumFastlaneVersion)'

            """

        //swiftlint:enable line_length

        //---

        return self
    }

    func require(
        _ gems: String...
        ) -> Self
    {
        gems.joined(separator: "\n")
            .split(separator: "\n")
            .map{ "fastlane_require '\($0)'" }
            .forEach{ requiredGems.insert($0) }
     
        //---
        
        return self
    }
    
    func add(
        _ customEntry: String
        ) -> Self
    {
        main <<< customEntry

        //---

        return self
    }
    
    func lane(
        _ laneName: String,
        body: () -> String
        ) -> Self
    {
        main <<< """

            lane :\(laneName) do
            """
        
        main.appendNewLine()

        main.indentation.nest{

            main <<< body()
        }

        main <<< """

            end # lane :\(laneName)
            """

        //---
        
        return self
    }
}
