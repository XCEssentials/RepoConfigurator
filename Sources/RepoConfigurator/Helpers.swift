import Foundation

//---

public
enum PathPrefix
{
    public
    static
    let root = URL(fileURLWithPath: "/")

    public
    static
    let userHomeDir = FileManager
        .default
        .homeDirectoryForCurrentUser

    public
    static
    let iCloudDrive = try! FileManager
        .default
        .url(for: .libraryDirectory,
             in: .userDomainMask,
             appropriateFor: nil,
             create: false)
        .appendingPathComponent("Mobile Documents/com~apple~CloudDocs")
}

//---

public
extension String
{
    func writeToFile(
        named fileName: String,
        at targetPath: URL,
        trimRepeatingEmptyLines: Bool = true
        ) throws
    {
        var fileContent = self

        //---

        if
            trimRepeatingEmptyLines
        {
            fileContent = fileContent
                .recursiveReplacingOccurrences(of: " \n", with: "\n")
                .recursiveReplacingOccurrences(of: "\n\n\n", with: "\n\n")
                .trimmingCharacters(in: .whitespacesAndNewlines)
        }

        //---

        try fileContent.write(
            to: targetPath.appendingPathComponent(fileName, isDirectory: false),
            atomically: true,
            encoding: .utf8
        )
    }

    //---

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
