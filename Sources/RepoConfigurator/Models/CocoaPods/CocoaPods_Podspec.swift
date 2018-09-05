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
    struct Podspec: ArbitraryNamedTextFile
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

        fileprivate
        enum GeneralSettings {}

        fileprivate
        enum SubSpec {}

        fileprivate
        enum PerPlatformSettings {}

        // MARK: Instance level members

        public
        let fileContent: IndentedText
    }
}

// MARK: - Presets

public
extension CocoaPods.Podspec
{
    static
    func standard(
        product: Product,
        company: Company,
        initialVersion: VersionString = Defaults.initialVersionString,
        license: License,
        authors: [Author],
        cocoapodsVersion: VersionString? = Defaults.cocoapodsVersion,
        swiftVersion: VersionString? = Defaults.swiftVersion,
        otherSettings: [(
            deploymentTarget: DeploymentTarget?,
            settigns: [String]
        )],
        customEntries: String...
        ) -> CocoaPods.Podspec
    {
        let specVar = Defaults.specVariable

        //---
        
        let result = IndentedTextBuffer()

        //---

        result <<< """
            Pod::Spec.new do |\(specVar)|

            """

        result.indentation.nest{

            result <<< TextFileSection<GeneralSettings>(
                specVar: specVar,
                product: product,
                company: company,
                initialVersion: initialVersion,
                license: license,
                authors: authors,
                cocoapodsVersion: cocoapodsVersion,
                swiftVersion: swiftVersion
            )

            result <<< otherSettings.map{

                TextFileSection<PerPlatformSettings>(
                    specVar: specVar,
                    deploymentTarget: $0.deploymentTarget,
                    settigns: $0.settigns
                )
            }

            result <<< customEntries.map{ """

                \($0)
                """
            }
        }

        result <<< """

            end # spec
            """

        //---

        return .init(fileContent: result.content)
    }

    static
    func withSubSpecs(
        product: Product,
        company: Company,
        initialVersion: VersionString = Defaults.initialVersionString,
        license: License,
        authors: [Author],
        cocoapodsVersion: VersionString? = Defaults.cocoapodsVersion,
        swiftVersion: VersionString? = Defaults.swiftVersion,
        subSpecs: [(
            name: String,
            perPlatfromSettings: [(
                deploymentTarget: DeploymentTarget?,
                settigns: [String]
            )]
        )],
        customEntries: String...
        ) -> CocoaPods.Podspec
    {
        let specVar = Defaults.specVariable
        let subSpecVar = Defaults.subSpecVariable

        //---

        let result = IndentedTextBuffer()

        //---

        result <<< """
            Pod::Spec.new do |\(specVar)|

            """

        result.indentation.nest{

            result <<< TextFileSection<GeneralSettings>(
                specVar: specVar,
                product: product,
                company: company,
                initialVersion: initialVersion,
                license: license,
                authors: authors,
                cocoapodsVersion: cocoapodsVersion,
                swiftVersion: swiftVersion
            )

            result <<< subSpecs.map{

                TextFileSection<SubSpec>(
                    parentSpecVar: specVar,
                    specName: $0.name,
                    specVar: subSpecVar,
                    perPlatfromSettings: $0.perPlatfromSettings
                )
            }

            result <<< customEntries.map{ """

                \($0)
                """
            }
        }

        result <<< """

            end # spec
            """

        //---

        return .init(fileContent: result.content)
    }
}

// MARK: - Content rendering

fileprivate
extension TextFileSection
    where
    Context == CocoaPods.Podspec.GeneralSettings
{
    init(
        specVar: String,
        product: CocoaPods.Podspec.Product,
        company: CocoaPods.Podspec.Company,
        initialVersion: VersionString = Defaults.initialVersionString,
        license: CocoaPods.Podspec.License,
        authors: [CocoaPods.Podspec.Author],
        cocoapodsVersion: VersionString? = Defaults.cocoapodsVersion,
        swiftVersion: VersionString? = Defaults.swiftVersion
        )
    {
        contentGetter = {

            indentation in

            //---

            let result: IndentedTextBuffer = .init(with: indentation)

            //---

            let s = specVar // swiftlint:disable:this identifier_name

            //swiftlint:disable line_length

            result <<< """
                \(s).name          = '\(company.prefix)\(product.name)'
                \(s).summary       = '\(product.summary)'
                \(s).version       = '\(initialVersion)'
                \(s).homepage      = 'https://\(company.name).github.io/\(product.name)'

                \(s).source        = { :git => 'https://github.com/\(company.name)/\(product.name).git', :tag => \(s).version }

                \(s).requires_arc  = true

                \(s).license       = { :type => '\(license.type)', :file => '\(license.fileName)' }

                \(s).authors = {
                """

            //swiftlint:enable line_length

            indentation.nest{

                result <<< authors.map{ """
                    '\($0.name)' => '\($0.email)'
                    """
                }
            }

            result <<< """
                } # authors

                \(swiftVersion.map{ "\(s).swift_version = '\($0)'" } ?? "")

                \(cocoapodsVersion.map{ "\(s).cocoapods_version = '>= \($0)'" } ?? "")

                """

            //---

            return result.content
        }
    }
}

fileprivate
extension TextFileSection
    where
    Context == CocoaPods.Podspec.SubSpec
{
    init(
        parentSpecVar: String,
        specName: String,
        specVar: String,
        perPlatfromSettings: [(
            deploymentTarget: DeploymentTarget?,
            settigns: [String]
        )]
        )
    {
        contentGetter = {

            indentation in

            //---

            let result: IndentedTextBuffer = .init(with: indentation)

            //---

            result <<< """
                \(parentSpecVar).subspec '\(specName)' do |\(specVar)|

                """

            indentation.nest{

                result <<< perPlatfromSettings.map{

                    TextFileSection<CocoaPods.Podspec.PerPlatformSettings>(
                        specVar: specVar,
                        deploymentTarget: $0.deploymentTarget,
                        settigns: $0.settigns
                    )
                }
            }

            result <<< """

                end # subSpec '\(specName)'
                """

            //---

            return result.content
        }
    }
}

fileprivate
extension TextFileSection
    where
    Context == CocoaPods.Podspec.PerPlatformSettings
{
    init(
        specVar: String,
        deploymentTarget: DeploymentTarget?,
        settigns: [String]
        )
    {
        contentGetter = {

            indentation in

            //---

            let result: IndentedTextBuffer = .init(with: indentation)

            //---

            let platfromId = deploymentTarget.map{ $0.platform }
            let platfromPrefix = platfromId.map{ "\($0.cocoaPodsId)." }
            let prefix = "\(specVar).\(platfromPrefix ?? "")"

            result <<< """

                # === \(platfromId.map{ "\($0.rawValue)" } ?? "All platforms")

                """

            result <<< deploymentTarget.map{ """
                \(prefix)deployment_target = '\($0.minimumVersion)'

                """
            }

            result <<< settigns.map{ """
                \(prefix)\($0)
                """
            }

            //---

            return result.content
        }
    }
}
