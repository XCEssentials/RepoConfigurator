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
        at targetFolder: URL,
        trimRepeatingEmptyLines: Bool = true,
        ifFileExists: RawTextFile.IfFileExistsPolicy = .override
        ) throws -> Bool
    {
        return try RawTextFile(
            fileName: fileName,
            targetFolder: targetFolder,
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
        at targetFolder: URL,
        trimRepeatingEmptyLines: Bool = true,
        ifFileExists: RawTextFile.IfFileExistsPolicy = .override
        ) throws -> Bool
    {
        return try RawTextFile(
            fileName: type(of: self).fileName,
            targetFolder: targetFolder,
            content: prepareContent()
            )
            .writeToFileSystem(
                trimRepeatingEmptyLines: trimRepeatingEmptyLines,
                ifFileExists: ifFileExists
            )
    }
}
