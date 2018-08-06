public
protocol TextFile
{
    var fileContent: IndentedText { get }
}

//---

public
protocol ArbitraryNamedTextFile: TextFile
{
    var fileName: String { get }
}

public
extension ArbitraryNamedTextFile
{
    func writeToFileSystem(
        at targetFolder: URL,
        trimRepeatingEmptyLines: Bool = true,
        ifFileExists: RawTextFile.IfFileExistsPolicy = .override
        ) throws -> Bool
    {
        return try RawTextFile(
            fileName: fileName,
            targetFolder: targetFolder,
            content: fileContent
            )
            .writeToFileSystem(
                trimRepeatingEmptyLines: trimRepeatingEmptyLines,
                ifFileExists: ifFileExists
            )
    }
}

//---

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
        ifFileExists: RawTextFile.IfFileExistsPolicy = .override
        ) throws -> Bool
    {
        return try RawTextFile(
            fileName: type(of: self).fileName,
            targetFolder: targetFolder,
            content: fileContent
            )
            .writeToFileSystem(
                trimRepeatingEmptyLines: trimRepeatingEmptyLines,
                ifFileExists: ifFileExists
            )
    }
}

//---

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

//---

public
protocol ConfigurableTextFile: TextFile
{
    associatedtype Section: TextFilePiece

    init(
        fileContent: IndentedText
        )
}

public
extension ConfigurableTextFile
{
    public
    init(
        sections: [Section]
        )
    {
        self.init(
            fileContent: sections
                .map{ $0.asIndentedText() }
                .reduce(into: IndentedText()){ $0 += $1 }
        )
    }

    public
    init(
        _ sections: Section...
        )
    {
        self.init(sections: sections)
    }

    public
    init(
        basedOn preset: Self,
        _ otherSections: Section...
        )
    {
        self.init(
            fileContent: preset.fileContent +
                Self(sections: otherSections).fileContent
        )
    }
}
