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

extension String
{
    func asIndentedText(
        with indentation: Indentation = Indentation()
        ) -> IndentedText
    {
        return split(separator: "\n").map{ (indentation, String($0)) }
    }
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
    let targetPath: URL

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
        ) throws
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

        try fileContent.write(
            to: targetPath.appendingPathComponent(
                fileName,
                isDirectory: false
            ),
            atomically: true,
            encoding: .utf8
        )
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
