// internal
enum Utils
{
    static
    func writeToFileSystem(
        _ fileContent: IndentedText,
        fileName: String,
        targetFolder: URL,
        trimRepeatingEmptyLines: Bool = true,
        ifFileExists: IfFileExistsWritePolicy = .override
        ) throws -> Bool
    {
        var buf = fileContent
            .map{ "\($0.rendered)\($1)" }
            .joined(separator: "\n")

        //---

        if
            trimRepeatingEmptyLines
        {
            buf = buf
                .recursiveReplacingOccurrences(of: " \n", with: "\n")
                .recursiveReplacingOccurrences(of: "\n\n\n", with: "\n\n")
                .trimmingCharacters(in: .whitespacesAndNewlines)
        }

        //---

        let fullFileName = targetFolder.appendingPathComponent(
            fileName,
            isDirectory: false
        )

        if
            (ifFileExists == .override) ||
                !FileManager.default.fileExists(atPath: fullFileName.path)
        {
            try buf.write(
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
