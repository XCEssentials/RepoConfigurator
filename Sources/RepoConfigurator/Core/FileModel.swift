public
protocol FileModel
{
    func prepareContent() throws -> IndentedText
}

//---

public
protocol ArbitraryNamedFile: FileModel
{
    var fileName: String { get }
}

public
extension ArbitraryNamedFile
{
    func writeToFileSystem(
        at targetPath: URL,
        trimRepeatingEmptyLines: Bool = true,
        ifFileExists: RawTextFile.IfFileExistsPolicy = .override
        ) throws
    {
        try RawTextFile(
            fileName: fileName,
            targetPath: targetPath,
            content: prepareContent()
            )
            .writeToFileSystem(
                trimRepeatingEmptyLines: trimRepeatingEmptyLines,
                ifFileExists: ifFileExists
            )
    }
}

//---

public
protocol FixedNameFile: FileModel
{
    static
    var fileName: String { get }
}

public
extension FixedNameFile
{
    func writeToFileSystem(
        at targetPath: URL,
        trimRepeatingEmptyLines: Bool = true,
        ifFileExists: RawTextFile.IfFileExistsPolicy = .override
        ) throws
    {
        try RawTextFile(
            fileName: type(of: self).fileName,
            targetPath: targetPath,
            content: prepareContent()
            )
            .writeToFileSystem(
                trimRepeatingEmptyLines: trimRepeatingEmptyLines,
                ifFileExists: ifFileExists
            )
    }
}
