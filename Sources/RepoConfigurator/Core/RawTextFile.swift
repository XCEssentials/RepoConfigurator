import Foundation

//---

public
struct RawTextFile<T: TextFile>
{
    // MARK: - Type level members

    public
    enum IfFileExistsWritePolicy
    {
        case doNotWrite
        case override
    }

    // MARK: - Instance level members

    public
    let model: T

    public
    let name: String

    public
    let targetFolder: URL

    public
    let shouldRemoveSpacesAtEOL: Bool

    public
    let shouldRemoveRepeatingEmptyLines: Bool

    //---

    public
    var content: String
    {
        var result = model
            .fileContent
            .rendered

        //---

        if
            shouldRemoveSpacesAtEOL
        {
            result = result
                .recursiveReplacingOccurrences(of: " \n", with: "\n")
        }

        if
            shouldRemoveRepeatingEmptyLines
        {
            result = result
                .recursiveReplacingOccurrences(of: "\n\n\n", with: "\n\n")
        }

        //---

        return result
    }

    public
    var fullFileName: URL
    {
        return targetFolder
            .appendingPathComponent(name, isDirectory: false)
    }

    //---

    public
    func writeToFileSystem(
        ifFileExists: IfFileExistsWritePolicy = .override
        ) throws -> Bool
    {
        // lets makre sure folders up to this file exists

        let pathToFolder = fullFileName
            .deletingLastPathComponent()
            .path

        if
            !FileManager
                .default
                .fileExists(atPath: pathToFolder)
        {
            try FileManager
                .default
                .createDirectory(
                    atPath: pathToFolder,
                    withIntermediateDirectories: true,
                    attributes: nil
                )
        }

        //---

        if
            (ifFileExists == .override) ||
            !FileManager.default.fileExists(atPath: fullFileName.path)
        {
            try content.write(
                to: fullFileName,
                atomically: true,
                encoding: .utf8
            )

            return true
        }
        else
        {
            return false
        }
    }
}

//---

fileprivate
extension String
{
    func recursiveReplacingOccurrences(
        of wanted: String,
        with replacement: String
        ) -> String
    {
        var result = self

        //---

        var previousResult: String

        repeat
        {
            previousResult = result
            result = result.replacingOccurrences(of: wanted, with: replacement)
        }
            while
            result != previousResult

        //---

        return result
    }
}
