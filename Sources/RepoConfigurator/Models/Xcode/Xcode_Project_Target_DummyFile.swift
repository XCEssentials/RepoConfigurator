public
extension Xcode.Project.Target
{
    public
    struct DummyFile: FixedNameTextFile
    {
        // MARK: - Type level members

        public
        static
        let fileName: String = "DummyFile.swift"

        // MARK: - Instance level members

        public
        let fileContent: IndentedText = []

        // MARK: - Initializers

        public
        init() {}
    }
}
