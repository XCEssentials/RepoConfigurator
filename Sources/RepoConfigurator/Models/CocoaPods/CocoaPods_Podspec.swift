public
extension CocoaPods
{
    public
    struct Podspec: ArbitraryNamedTextFile, ConfigurableTextFile
    {
        // MARK: - Type level members

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
        enum Section: TextFilePiece
        {
            case header(
                specVar: String
            )

            case generalInfo(
                specVar: String,
                product: Product,
                company: Company,
                initialVersion: VersionString,
                license: License,
                author: Author,
                swiftVersion: VersionString?
            )

            // single platform, single subspec
            case basicPod(
                specVar: String,
                deploymentTarget: DeploymentTarget,
                sourcesPath: String,
                usesSwift: Bool // ObjC if NO
            )

            case custom(
                String
            )

            case footer
        }

        // MARK: - Instance level members

        public
        var fileContent: IndentedText = []

        // MARK: - Initializers

        public
        init() {}
    }
}

// MARK: - Presets

public
extension CocoaPods.Podspec
{
    public
    static
    func standard(
        specVar: String = Defaults.specVariable,
        product: Product,
        company: Company,
        initialVersion: VersionString = Defaults.initialVersionString,
        license: License,
        author: Author,
        swiftVersion: VersionString?,
        deploymentTarget: DeploymentTarget,
        sourcesPath: String = Defaults.pathToSourcesFolder,
        otherEntries: [String] = []
        ) -> CocoaPods.Podspec
    {
        var sections: [Section] = [

            .header(
                specVar: specVar
            ),
            .generalInfo(
                specVar: specVar,
                product: product,
                company: company,
                initialVersion: initialVersion,
                license: license,
                author: author,
                swiftVersion: swiftVersion
            ),
            .basicPod(
                specVar: specVar,
                deploymentTarget: deploymentTarget,
                sourcesPath: sourcesPath,
                usesSwift: (swiftVersion != nil)
            )
        ]

        sections += otherEntries.map{ .custom($0) }

        sections += [.footer]

        //---

        return .init(sections: sections)
    }
}

// MARK: - Content rendering

public
extension CocoaPods.Podspec.Section
{
    func asIndentedText(
        with indentation: inout Indentation
        ) -> IndentedText
    {
        // NOTE: depends on 'Xcodeproj' CL tool

        var result: IndentedText = []

        //---

        switch self
        {
        case .header(
            let specVar
            ):
            result <<< """
                Pod::Spec.new do |\(specVar)|

                """
                .asIndentedText(with: &indentation)

            indentation++

        case .generalInfo(
            let specVar,
            let product,
            let company,
            let initialVersion,
            let license,
            let author,
            let swiftVersion
            ):
            //swiftlint:disable line_length
            result <<< """
                \(specVar).name          = '\(company.prefix)\(product.name)'
                \(specVar).summary       = '\(product.summary)'
                \(specVar).version       = '\(initialVersion)'
                \(specVar).homepage      = 'https://\(company.name).github.io/\(product.name)'

                \(specVar).source        = { :git => 'https://github.com/\(company.name)/\(product.name).git', :tag => \(specVar).version }

                \(specVar).requires_arc  = true

                \(specVar).license       = { :type => '\(license.type)', :file => '\(license.fileName)' }
                \(specVar).author        = { '\(author.name)' => '\(author.email)' }
                """
                .asIndentedText(with: &indentation)

            //swiftlint:enable line_length

            swiftVersion.map{

                // NOTE: same indentation!

                result <<< """

                    \(specVar).swift_version = '\($0)'
                    """
                    .asIndentedText(with: &indentation)
            }

        case .basicPod(
            let specVar,
            let deploymentTarget,
            let sourcesPath,
            let usesSwift
            ):
            //swiftlint:disable line_length
            result <<< """

                \(specVar).\(deploymentTarget.platform.cocoaPodsId).deployment_target = '\(deploymentTarget.minimumVersion)'

                \(specVar).source_files = '\(sourcesPath)/**/*.\(usesSwift ? "swift" : "{h,m}")'
                """
                .asIndentedText(with: &indentation)
            //swiftlint:enable line_length

        case .custom(
            let customEntry
            ):
            result <<< """

                \(customEntry)
                """
                .asIndentedText(with: &indentation)

        case .footer:
            indentation--

            result <<< """

                end
                """
                .asIndentedText(with: &indentation)
        }

        //---

        return result
    }
}
