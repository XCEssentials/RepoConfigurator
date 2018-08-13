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
    public
    struct Standard: ArbitraryNamedTextFile
    {
        // MARK: - Type level members

        public
        typealias Parent = CocoaPods.Podspec

        // MARK: - Instance level members

        public private(set)
        var fileContent: [IndentedTextGetter] = []

        // MARK: - Initializers

        init(
            specVar: String = Defaults.specVariable,
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
            )]
            )
        {
            fileContent <<<  Parent.Settings(
                specVar: specVar,
                product: product,
                company: company,
                initialVersion: initialVersion,
                license: license,
                authors: authors,
                cocoapodsVersion: cocoapodsVersion,
                swiftVersion: swiftVersion,
                otherSettings: otherSettings.map{

                    Parent.PerPlatformSettings(
                        specVar: specVar,
                        deploymentTarget: $0.deploymentTarget,
                        settigns: $0.settigns
                    )
                }
            )
        }
    }
}
