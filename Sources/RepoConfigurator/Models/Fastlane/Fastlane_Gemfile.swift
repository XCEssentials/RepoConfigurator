public
extension Fastlane
{
    public
    struct Gemfile: FixedNameTextFile, ConfigurableTextFile
    {
        // MARK: - Type level members

        public
        enum Section: TextFilePiece
        {
            case defaultHeader

            case fastlane

            case custom(
                String
            )
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
extension Fastlane.Gemfile
{
    /**
     https://docs.fastlane.tools/getting-started/ios/setup/#use-a-gemfile
     */
    static
    func fastlaneSupportOnly() -> Fastlane.Gemfile
    {
        return .init(
            .defaultHeader,
            .fastlane
        )
    }
}

// MARK: - Content rendering

public
extension Fastlane.Gemfile.Section
{
    func asIndentedText(
        with indentation: inout Indentation
        ) -> IndentedText
    {
        var result: IndentedText = []

        //---

        switch self
        {
        case .defaultHeader:
            result <<< """
                source "https://rubygems.org"

                """
                .asIndentedText(with: &indentation)

        case .fastlane:
            result <<< """

                gem "fastlane"
                """
                .asIndentedText(with: &indentation)

        case .custom(
            let customEntry
            ):
            result <<< """

                \(customEntry)
                """
                .asIndentedText(with: &indentation)
        }

        //---

        return result
    }
}
