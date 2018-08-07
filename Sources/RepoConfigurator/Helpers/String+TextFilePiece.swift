extension String: TextFilePiece
{
    public
    func asIndentedText(
        with indentation: inout Indentation
        ) -> IndentedText
    {
        return split(separator: "\n").map{ (indentation, String($0)) }
    }
}
