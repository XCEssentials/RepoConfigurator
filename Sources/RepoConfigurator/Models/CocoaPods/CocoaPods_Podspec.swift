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
    enum Podspec
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
            fileName: String
        )

        public
        typealias Author = (
            name: String,
            email: String
        )

        // internal
        struct Settings
        {
            let specVar: String
            let product: Product
            let company: Company
            let initialVersion: VersionString
            let license: License
            let authors: [Author]
            let cocoapodsVersion: VersionString? // for ex. '>= 0.36'
            let swiftVersion: VersionString?
            let otherSettings: TextFilePiece
        }

        // internal
        struct PerPlatformSettings
        {
            let specVar: String
            let deploymentTarget: DeploymentTarget?
            let settigns: [String]
        }
    }
}

// MARK: - Content rendering

//internal
extension CocoaPods.Podspec.Settings: TextFilePiece
{
    func asIndentedText(
        with indentation: Indentation
        ) -> IndentedText
    {
        let result: IndentedTextBuffer = .init(with: indentation)

        //---

        let s = specVar // swiftlint:disable:this identifier_name

        result <<< """
            Pod::Spec.new do |\(s)|

            """

        indentation.nest{

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
                    "'\($0.name)' => '\($0.email)'"
                    """
                }
            }

            result <<< """
                } # authors

                \(swiftVersion.map{ "\(s).swift_version = '\($0)'" } ?? "")

                \(cocoapodsVersion.map{ "\(s).cocoapods_version = '>= \($0)'" } ?? "")

                """

            result <<< otherSettings
                .asIndentedText(with: indentation)
        }

        // end spec
        result <<< """

            end # spec
            """

        //---

        return result.content
    }
}

//internal
extension CocoaPods.Podspec.PerPlatformSettings: TextFilePiece
{
    func asIndentedText(
        with indentation: Indentation
        ) -> IndentedText
    {
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
