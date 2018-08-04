public
protocol FileModel
{
    var fileContent: String { get }
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
    func writeToFile(
        at targetPath: URL,
        trimRepeatingEmptyLines: Bool = true
        ) throws
    {
        try fileContent.writeToFile(
            named: fileName,
            at: targetPath,
            trimRepeatingEmptyLines: trimRepeatingEmptyLines
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
    func writeToFile(
        at targetPath: URL,
        trimRepeatingEmptyLines: Bool = true
        ) throws
    {
        try fileContent.writeToFile(
            named: type(of: self).fileName,
            at: targetPath,
            trimRepeatingEmptyLines: trimRepeatingEmptyLines
        )
    }
}
