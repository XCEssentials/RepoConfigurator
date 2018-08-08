extension String: TextFilePiece
{
    public
    func asIndentedText(
        with indentation: inout Indentation
        ) -> IndentedText
    {
        return split(
            separator: "\n",
            omittingEmptySubsequences: false // to preserve empty lines!
            )
            .map{ (indentation, String($0)) }
    }
}
