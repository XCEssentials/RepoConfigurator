public
extension GitHub
{
    public
    struct Pages: FixedNameTextFile, ConfigurableTextFile
    {
        // MARK: - Type level members

        public
        static
        let fileName: String = "_config.yml"

        public
        enum Section: TextFilePiece
        {
            case theme(String)
            case custom(String)
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
extension GitHub.Pages
{
    static
    func openSourceFramework(
        themeName: String = "jekyll-theme-cayman",
        otherEntries: String...
        ) -> GitHub.Pages
    {
        var sections: [Section] = [

            .theme(
                themeName
            )
        ]

        sections += otherEntries
            .map{ .custom($0) }

        //---

        return .init(sections: sections)
    }
}

// MARK: - Content rendering

public
extension GitHub.Pages.Section
{
    func asIndentedText(
        with indentation: inout Indentation
        ) -> IndentedText
    {
        let result: String

        //---

        switch self
        {
        case .theme(
            let themeName
            ):
            result = """

                theme: \(themeName)
                """

        case .custom(
            let customEntry
            ):
            result = """

                \(customEntry)
                """
        }

        //---

        return result.asIndentedText(with: &indentation)
    }
}
