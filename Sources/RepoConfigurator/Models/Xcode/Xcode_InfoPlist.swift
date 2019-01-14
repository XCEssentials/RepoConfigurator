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

import FileKit

//---

public
extension Xcode
{
    public
    final
    class InfoPlist: ArbitraryNamedTextFile
    {
        // MARK: Type level members

        public
        enum PackageType: String
        {
            case app = "APPL"
            case framework = "FMWK"
            case tests = "BNDL"
        }

        // MARK: Instance level members

        private
        var buffer = IndentedTextBuffer()
        
        public
        var fileContent: IndentedText
        {
            return buffer.content
        }

        // MARK: Initializers

        public
        init(
            for packageType: PackageType,
            initialVersionString: VersionString = Defaults.initialVersionString,
            initialBuildNumber: BuildNumber = Defaults.initialBuildNumber,
            preset: Preset?,
            otherEntries: [String] = []
            )
        {
            let sections = Sections(buffer: buffer)
            
            //---
            
            sections.header()
            
            sections.basic(
                packageType: packageType,
                initialVersionString: initialVersionString,
                initialBuildNumber: initialBuildNumber
            )
            
            switch preset
            {
            case .some(.iOS) where packageType == .app:
                sections.iOSApp()

            case .some(.macOS(let year, let entity)) where packageType == .app:
                sections.macOSApp(
                    copyrightYear: year,
                    copyrightEntity: entity
                )

            case .some(.macOS(let year, let entity)) where packageType == .framework:
                sections.macOSFramework(
                    copyrightYear: year,
                    copyrightEntity: entity
                )

            default:
                break
            }

            buffer <<< otherEntries

            sections.footer()
        }
    }
}

// MARK: - Convenience helpers

public
extension Xcode.InfoPlist
{
    static
    func prepare<T: XcodeProjectTarget>(
        for target: T,
        initialVersionString: VersionString = Defaults.initialVersionString,
        initialBuildNumber: BuildNumber = Defaults.initialBuildNumber,
        otherEntries: [String] = [],
        companyName: String? = nil, // for macOS
        absolutePrefixLocation: Path? = nil,
        removeSpacesAtEOL: Bool = true,
        removeRepeatingEmptyLines: Bool = true
        ) throws -> PendingTextFile<Xcode.InfoPlist>
    {
        guard
            Array(Spec.Product.deploymentTargets.keys)
                .contains(target.deploymentTarget.platform)
        else
        {
            fatalError("❌ Attempt to generate info file for unsupported platform \(target.deploymentTarget.platform)!")
        }
    
        //---
    
        let preset: Xcode.InfoPlist.Preset?
    
        switch target.deploymentTarget.platform
        {
        case .iOS:
            preset = .iOS
            
        case .macOS:
            preset = try .macOS(
                copyrightYear: Spec.Product.copyrightYear,
                copyrightEntity: companyName
                    ?? Spec.Company().name
            )
            
        default:
            preset = nil
        }
    
        //---
    
        return try self
            .init(
                for: target.packageType,
                initialVersionString: initialVersionString,
                initialBuildNumber: initialBuildNumber,
                preset: preset,
                otherEntries: otherEntries
            )
            .prepare(
                relativeLocation: target.infoPlistLocation,
                absolutePrefixLocation: absolutePrefixLocation,
                removeSpacesAtEOL: removeSpacesAtEOL,
                removeRepeatingEmptyLines: removeRepeatingEmptyLines
            )
    }
}

// MARK: - Presets

public
extension Xcode.InfoPlist
{
    public
    enum Preset
    {
        case iOS

        case macOS(
            copyrightYear: UInt,
            copyrightEntity: String
        )

        //---

        static
        func macOSWithCurrentYear(
            copyrightEntity: String
            ) -> Preset
        {
            return .macOS(
                copyrightYear: Spec.Product.copyrightYear,
                copyrightEntity: copyrightEntity
            )
        }
    }
}
