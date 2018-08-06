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
