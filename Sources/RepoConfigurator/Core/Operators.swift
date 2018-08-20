/*

 MIT License

 Copyright (c) 2018 Maxim Khatskevich

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.

 */

infix operator <<<

// MARK: - String <<<

public
func <<< (
    keyName: String,
    value: String
    ) -> KeyValuePair
{
    return (keyName, value)
}

public
func <<< (
    list: inout [String],
    element: String
    )
{
    list += [element]
}

public
func <<< (
    list: inout [String],
    element: String?
    )
{
    if
        let element = element
    {
        list += [element]
    }
}

public
func <<< (
    list: inout [String],
    elements: [String]
    )
{
    list += elements
}

// MARK: - IndentedText <<<

public
func <<< (
    list: inout IndentedText,
    element: IndentedTextLine
    )
{
    list += [element]
}

public
func <<< (
    list: inout IndentedText,
    elements: IndentedText
    )
{
    list += elements
}

public
func <<< (
    list: inout IndentedText,
    elements: [IndentedText]
    )
{
    list += elements.flatMap{ $0 }
}

//// MARK: - [IndentedTextGetter] <<<
//
//public
//func <<< (
//    list: inout [IndentedTextGetter],
//    element: @escaping IndentedTextGetter
//    )
//{
//    list += [element]
//}
//
//public
//func <<< (
//    list: inout [IndentedTextGetter],
//    anotherList: [IndentedTextGetter]
//    )
//{
//    list += anotherList
//}
//
//public
//func <<< (
//    list: inout [IndentedTextGetter],
//    element: TextFilePiece
//    )
//{
//    list += [element.asIndentedText]
//}
//
//public
//func <<< (
//    list: inout [IndentedTextGetter],
//    element: TextFilePiece?
//    )
//{
//    if
//        let element = element
//    {
//        list += [element.asIndentedText]
//    }
//}
//
//public
//func <<< (
//    list: inout [IndentedTextGetter],
//    anotherList: [TextFilePiece]
//    )
//{
//    list += anotherList.map{ $0.asIndentedText }
//}
//
//public
//func <<< (
//    list: inout [IndentedTextGetter],
//    anotherList: [TextFilePiece]?
//    )
//{
//    if
//        let anotherList = anotherList
//    {
//        list += anotherList.map{ $0.asIndentedText }
//    }
//}

// MARK: - IndentedTextBuffer <<<

public
func <<< (
    receiver: IndentedTextBuffer,
    input: String
    )
{
    receiver.append(input)
}

public
func <<< (
    receiver: IndentedTextBuffer,
    input: String?
    )
{
    if
        let input = input
    {
        receiver.append(input)
    }
}

public
func <<< (
    receiver: IndentedTextBuffer,
    inputs: [String]
    )
{
    inputs.forEach{

        receiver.append($0)
    }
}

public
func <<< (
    receiver: IndentedTextBuffer,
    input: IndentedText
    )
{
    receiver.append(input)
}

public
func <<< (
    receiver: IndentedTextBuffer,
    inputs: [IndentedText]
    )
{
    inputs.forEach{

        receiver.append($0)
    }
}

public
func <<< (
    receiver: IndentedTextBuffer,
    input: TextFilePiece
    )
{
    receiver.append(input)
}

public
func <<< (
    receiver: IndentedTextBuffer,
    input: Dictionary<String, TextFilePiece>.Values
    )
{
    receiver.append(Array(input))
}
