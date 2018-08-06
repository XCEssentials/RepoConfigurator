// MARK: - Text File

public
protocol TextFile
{
    var fileContent: IndentedText { get }
}

// MARK: - ARBITRARY Named Text File

public
protocol ArbitraryNamedTextFile: TextFile {}

public
extension ArbitraryNamedTextFile
{
    func writeToFileSystem(
        fileName: String,
        at targetFolder: URL,
        trimRepeatingEmptyLines: Bool = true,
        ifFileExists: IfFileExistsWritePolicy = .override
        ) throws -> Bool
    {
        return try Utils
            .writeToFileSystem(
                fileContent,
                fileName: fileName,
                targetFolder: targetFolder,
                trimRepeatingEmptyLines: trimRepeatingEmptyLines,
                ifFileExists: ifFileExists
            )
    }
}

// MARK: - FIXED Named Text File

public
protocol FixedNameTextFile: TextFile
{
    static
    var fileName: String { get }
}

public
extension FixedNameTextFile
{
    func writeToFileSystem(
        at targetFolder: URL,
        trimRepeatingEmptyLines: Bool = true,
        ifFileExists: IfFileExistsWritePolicy = .override
        ) throws -> Bool
    {
        return try Utils
            .writeToFileSystem(
                fileContent,
                fileName: type(of: self).fileName,
                targetFolder: targetFolder,
                trimRepeatingEmptyLines: trimRepeatingEmptyLines,
                ifFileExists: ifFileExists
            )
    }
}

// MARK: - Text File Piece

public
protocol TextFilePiece
{
    func asIndentedText(
        with indentation: Indentation
        ) -> IndentedText
}

public
extension TextFilePiece
{
    func asIndentedText() -> IndentedText
    {
        return asIndentedText(with: Indentation())
    }
}

// MARK: - CONFIGURABLE Named Text File

public
protocol ConfigurableTextFile: TextFile
{
    associatedtype Section: TextFilePiece

    init()

    var fileContent: IndentedText { get set }
}

public
extension ConfigurableTextFile
{
    init(
        sections: [Self.Section]
        )
    {
        self.init()

        //---

        fileContent = sections
            .map{ $0.asIndentedText() }
            .reduce(into: IndentedText()){ $0 += $1 }
    }

    init(
        _ sections: Section...
        )
    {
        self.init(sections: sections)
    }

    init(
        basedOn preset: Self,
        _ otherSections: Section...
        )
    {
        self.init(
            basedOn: preset,
            otherSections: otherSections
        )
    }

    init(
        basedOn preset: Self,
        otherSections: [Section]
        )
    {
        self.init()

        //---

        fileContent = preset.fileContent +
            Self(sections: otherSections).fileContent
    }
}
