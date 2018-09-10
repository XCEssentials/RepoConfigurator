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
    class Podspec: ArbitraryNamedTextFile
    {
        // MARK: Type level members

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
            fileName: String
        )

        public
        typealias Author = (
            name: String,
            email: String
        )

        public
        struct PerPlatformSettings
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

        public
        struct SubSpecs
        {
            private
            let parentSpecVar: String

            private
            let specVar: String

            private
            let buffer: IndentedTextBuffer

            //internal
            init(
                parentSpecVar: String,
                specVar: String,
                buffer: IndentedTextBuffer
                )
            {
                self.parentSpecVar = parentSpecVar
                self.specVar = specVar
                self.buffer = buffer
            }
        }

        public
        struct TestSubSpecs
        {
            private
            let parentSpecVar: String

            private
            let specVar: String

            private
            let buffer: IndentedTextBuffer

            //internal
            init(
                parentSpecVar: String,
                specVar: String,
                buffer: IndentedTextBuffer
                )
            {
                self.parentSpecVar = parentSpecVar
                self.specVar = specVar
                self.buffer = buffer
            }
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

        //internal
        init() {}
    }
}

// MARK: - Presets

public
extension CocoaPods.Podspec
{
    static
    func standard(
        specVar: String = Defaults.specVariable,
        product: Product,
        company: Company,
        version: VersionString = Defaults.initialVersionString,
        license: License,
        authors: [Author],
        cocoapodsVersion: VersionString? = Defaults.cocoapodsVersion,
        swiftVersion: VersionString? = Defaults.swiftVersion,
        perPlatformSettings: (PerPlatformSettings) -> Void,
        customEntries: String...
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

            perPlatformSettings(
                PerPlatformSettings(
                    specVar: specVar,
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
        swiftVersion: VersionString? = Defaults.swiftVersion,
        subSpecs: (SubSpecs) -> Void,
        testSubSpecs: (TestSubSpecs) -> Void = { _ in },
        customEntries: String...
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

            subSpecs(
                SubSpecs(
                    parentSpecVar: specVar,
                    specVar: subSpecVar,
                    buffer: result.buffer
                )
            )

            testSubSpecs(
                TestSubSpecs(
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
        swiftVersion: VersionString? = Defaults.swiftVersion
        )
    {
        // https://guides.cocoapods.org/syntax/podspec.html#group_root_specification

        let s = specVar // swiftlint:disable:this identifier_name

        //swiftlint:disable line_length

        buffer <<< """
            \(s).name          = '\(company.prefix)\(product.name)'
            \(s).summary       = '\(product.summary)'
            \(s).version       = '\(version)'
            \(s).homepage      = 'https://\(company.name).github.io/\(product.name)'

            \(s).source        = { :git => 'https://github.com/\(company.name)/\(product.name).git', :tag => \(s).version }

            \(s).requires_arc  = true

            \(s).license       = { :type => '\(license.type)', :file => '\(license.fileName)' }

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

public
extension CocoaPods.Podspec.PerPlatformSettings
{
    func settings(
        for deploymentTarget: DeploymentTarget?,
        _ settigns: String...
        )
    {
        // https://guides.cocoapods.org/syntax/podspec.html#group_multi_platform_support

        let platfromId = deploymentTarget.map{ $0.platform }
        let platfromPrefix = platfromId.map{ "\($0.cocoaPodsId)." }
        let prefix = "\(specVar).\(platfromPrefix ?? "")"

        buffer <<< """

            # === \(platfromId.map{ "\($0.rawValue)" } ?? "All platforms")

            """

        buffer <<< deploymentTarget.map{ """
            \(prefix)deployment_target = '\($0.minimumVersion)'

            """
        }

        // might be a list of single lines,
        // one nultiline strings,
        // or a combination of single and multilines,
        // so lets flatten this out
        buffer <<< settigns.flatMap{ $0.split(separator: "\n") }.map{ """
            \(prefix)\($0)
            """
        }
    }
}

public
extension CocoaPods.Podspec.SubSpecs
{
    func subSpec(
        _ specName: String,
        perPlatformSettings: (CocoaPods.Podspec.PerPlatformSettings) -> Void
        )
    {
        // https://guides.cocoapods.org/syntax/podspec.html#subspec

        buffer <<< """
            \(parentSpecVar).subspec '\(specName)' do |\(specVar)|

            """

        buffer.indentation.nest{

            perPlatformSettings(
                CocoaPods.Podspec.PerPlatformSettings(
                    specVar: specVar,
                    buffer: buffer
                )
            )
        }

        buffer <<< """

            end # subspec '\(specName)'
            """
    }
}

public
extension CocoaPods.Podspec.TestSubSpecs
{
    func testSubSpec(
        _ specName: String,
        perPlatformSettings: (CocoaPods.Podspec.PerPlatformSettings) -> Void
        )
    {
        // https://guides.cocoapods.org/syntax/podspec.html#test_spec

        buffer <<< """
            \(parentSpecVar).test_spec '\(specName)' do |\(specVar)|

            """

        buffer.indentation.nest{

            perPlatformSettings(
                CocoaPods.Podspec.PerPlatformSettings(
                    specVar: specVar,
                    buffer: buffer
                )
            )
        }

        buffer <<< """

            end # test_spec '\(specName)'
            """
    }
}
