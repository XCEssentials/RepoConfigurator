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

import Foundation

import FileKit

//---

public
extension CocoaPods
{
    public
    final
    class Podspec: ArbitraryNamedTextFile
    {
        // MARK: Type level members

        public
        static
        let `extension`: String = String(describing: Podspec.self).lowercased()
        
        // MARK: Instance level members

        private
        var buffer: IndentedTextBuffer = .init()

        public
        var fileContent: IndentedText
        {
            return buffer.content
        }

        // MARK: Initializers

        //internal
        init() {}
    }
}

// MARK: - Convenience helpers

public
extension CocoaPods.Podspec
{
    func prepare(
        for cocoaPod: Spec.CocoaPod,
        removeSpacesAtEOL: Bool = true,
        removeRepeatingEmptyLines: Bool = true
        ) throws -> PendingTextFile<CocoaPods.Podspec>
    {
        return try prepare(
            at: cocoaPod.podspecLocation,
            removeSpacesAtEOL: removeSpacesAtEOL,
            removeRepeatingEmptyLines: removeRepeatingEmptyLines
        )
    }
}

// MARK: - Related types

public
extension CocoaPods.Podspec
{
    public
    typealias Product = (
        name: String,
        summary: String
    )

    public
    typealias Company = (
        name: String,
        identifier: String,
        prefix: String
    )

    public
    typealias License = (
        type: String,
        file: Path
    )

    public
    typealias Author = (
        name: String,
        email: String
    )
}

// MARK: - Presets

public
extension CocoaPods.Podspec
{
    static
    func standard(
        specVar: String = Defaults.specVariable,
        subSpecVar: String = Defaults.subSpecVariable,
        product: Product,
        company: Company,
        version: VersionString = Defaults.initialVersionString,
        license: License,
        authors: [Author],
        cocoapodsVersion: VersionString? = Defaults.cocoapodsVersion,
        swiftVersion: VersionString? = Spec.BuildSettings.swiftVersion.value,
        globalSettings: (PerPlatformSettingsContext) -> Void,
        testSubSpecs: (TestSubSpecsContext) -> Void = { _ in },
        customEntries: [String] = []
        ) -> CocoaPods.Podspec
    {
        let result: CocoaPods.Podspec = .init()

        //---

        result.buffer <<< """
            Pod::Spec.new do |\(specVar)|

            """

        result.buffer.indentation.nest{

            result.generalSettings(
                specVar: specVar,
                product: product,
                company: company,
                version: version,
                license: license,
                authors: authors,
                cocoapodsVersion: cocoapodsVersion,
                swiftVersion: swiftVersion
            )

            globalSettings(
                PerPlatformSettingsContext(
                    specVar: specVar,
                    buffer: result.buffer
                )
            )

            testSubSpecs(
                TestSubSpecsContext(
                    parentSpecVar: specVar,
                    specVar: subSpecVar,
                    buffer: result.buffer
                )
            )

            result.buffer <<< customEntries.map{ """

                \($0)
                """
            }
        }

        result.buffer <<< """

            end # spec \(specVar)

            """

        //---

        return result
    }

    static
    func withSubSpecs(
        specVar: String = Defaults.specVariable,
        subSpecVar: String = Defaults.subSpecVariable,
        product: Product,
        company: Company,
        version: VersionString = Defaults.initialVersionString,
        license: License,
        authors: [Author],
        cocoapodsVersion: VersionString? = Defaults.cocoapodsVersion,
        swiftVersion: VersionString? = Spec.BuildSettings.swiftVersion.value,
        globalSettings: (PerPlatformSettingsContext) -> Void,
        subSpecs: (SubSpecsContext) -> Void,
        testSubSpecs: (TestSubSpecsContext) -> Void = { _ in },
        customEntries: [String] = []
        ) -> CocoaPods.Podspec
    {
        let result: CocoaPods.Podspec = .init()

        //---

        result.buffer <<< """
            Pod::Spec.new do |\(specVar)|

            """

        result.buffer.indentation.nest{

            result.generalSettings(
                specVar: specVar,
                product: product,
                company: company,
                version: version,
                license: license,
                authors: authors,
                cocoapodsVersion: cocoapodsVersion,
                swiftVersion: swiftVersion
            )

            globalSettings(
                PerPlatformSettingsContext(
                    specVar: specVar,
                    buffer: result.buffer
                )
            )

            result.buffer.appendNewLine()
            
            result.buffer <<< """
                # === SUBSPECS ===

                """

            subSpecs(
                SubSpecsContext(
                    parentSpecVar: specVar,
                    specVar: subSpecVar,
                    buffer: result.buffer
                )
            )

            testSubSpecs(
                TestSubSpecsContext(
                    parentSpecVar: specVar,
                    specVar: subSpecVar,
                    buffer: result.buffer
                )
            )

            result.buffer <<< customEntries.map{ """

                \($0)
                """
            }
        }

        result.buffer <<< """

            end # spec \(specVar)

            """

        //---

        return result
    }
}

// MARK: - Content rendering

fileprivate
extension CocoaPods.Podspec
{
    func generalSettings(
        specVar: String,
        product: CocoaPods.Podspec.Product,
        company: CocoaPods.Podspec.Company,
        version: VersionString = Defaults.initialVersionString,
        license: CocoaPods.Podspec.License,
        authors: [CocoaPods.Podspec.Author],
        cocoapodsVersion: VersionString? = Defaults.cocoapodsVersion,
        swiftVersion: VersionString? = Spec.BuildSettings.swiftVersion.value
        )
    {
        // https://guides.cocoapods.org/syntax/podspec.html#group_root_specification

        let s = specVar // swiftlint:disable:this identifier_name

        //swiftlint:disable line_length

        buffer <<< """
            \(s).name          = '\(product.name)'
            \(s).summary       = '\(product.summary)'
            \(s).version       = '\(version)'
            \(s).homepage      = 'https://\(company.name).github.io/\(product.name)'

            \(s).source        = { :git => 'https://github.com/\(company.name)/\(product.name).git', :tag => \(s).version }

            \(s).requires_arc  = true

            \(s).license       = { :type => '\(license.type)', :file => '\(license.file.rawValue)' }

            \(s).authors = {
            """

        //swiftlint:enable line_length

        buffer.indentation.nest{

            buffer <<< authors.map{ """
                '\($0.name)' => '\($0.email)'
                """
            }
        }

        buffer <<< """
            } # authors

            \(swiftVersion.map{ "\(s).swift_version = '\($0)'" } ?? "")

            \(cocoapodsVersion.map{ "\(s).cocoapods_version = '>= \($0)'" } ?? "")
            """
    }
}
