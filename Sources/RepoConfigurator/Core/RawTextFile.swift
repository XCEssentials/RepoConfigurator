import Foundation

//---

public
typealias IndentedTextLine = (
    indentation: Indentation,
    content: String
)

//---

public
typealias IndentedText = [IndentedTextLine]

//---

public
func <<< (list: inout IndentedText, element: IndentedTextLine)
{
    list.append(element)
}

public
func <<< (list: inout IndentedText, elements: IndentedText)
{
    list.append(contentsOf: elements)
}

//---

public
struct RawTextFile
{
    public
    enum IfFileExistsPolicy
    {
        case doNotWrite
        case override
    }

    //---

    public
    let fileName: String

    public
    let targetFolder: URL

    public
    let content: IndentedText

    //---

    private
    func render() -> String
    {
        return content
            .map{ "\($0.rendered)\($1)" }
            .joined(separator: "\n")
    }

    func writeToFileSystem(
        trimRepeatingEmptyLines: Bool = true,
        ifFileExists: IfFileExistsPolicy = .override
        ) throws -> Bool
    {
        var fileContent = render()

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

        let fullFileName = targetFolder.appendingPathComponent(
            fileName,
            isDirectory: false
        )

        if
            (ifFileExists == .override) ||
            !FileManager.default.fileExists(atPath: fullFileName.path)
        {
            try fileContent.write(
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
