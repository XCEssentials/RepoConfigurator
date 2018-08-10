import Foundation

//---

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
    func prepare(
        name: String,
        targetFolder: URL,
        removeSpacesAtEOL: Bool = true,
        removeRepeatingEmptyLines: Bool = true
        ) -> RawTextFile<Self>
    {
        return RawTextFile(
            model: self,
            name: name,
            targetFolder: targetFolder,
            shouldRemoveSpacesAtEOL: removeSpacesAtEOL,
            shouldRemoveRepeatingEmptyLines: removeRepeatingEmptyLines
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
    static
    var fileName: String
    {
        // by default return intrinsic file name type based on type name

        return String
            .init(describing: self)
            .components(
                separatedBy: .whitespacesAndNewlines
            )
            .first
            ??
        ""
    }

    var fileName: String
    {
        return Self.fileName
    }

    func prepare(
        targetFolder: URL,
        removeSpacesAtEOL: Bool = true,
        removeRepeatingEmptyLines: Bool = true
        ) -> RawTextFile<Self>
    {
        return RawTextFile(
            model: self,
            name: type(of: self).fileName,
            targetFolder: targetFolder,
            shouldRemoveSpacesAtEOL: removeSpacesAtEOL,
            shouldRemoveRepeatingEmptyLines: removeRepeatingEmptyLines
        )
    }
}

// MARK: - Text File Piece

public
protocol TextFilePiece
{
    func asIndentedText(
        with indentation: inout Indentation
        ) -> IndentedText
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

        var indentation = Indentation()

        fileContent = sections
            .map{ $0.asIndentedText(with: &indentation) }
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
