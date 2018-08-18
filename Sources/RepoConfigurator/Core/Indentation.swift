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

public
struct Indentation: Equatable
{
    public
    let singleLevel: String

    public private(set)
    var currentLevel = 0

    //---

    public
    init(
        singleLevel: String = .init(repeating: " ", count: 4),
        currentLevel: Int = 0
        )
    {
        self.singleLevel = singleLevel
        self.currentLevel = currentLevel
    }

    public
    var rendered: String
    {
        return String(repeating: singleLevel, count: currentLevel)
    }

    public
    mutating
    func increaseLevel()
    {
        currentLevel += 1
    }

    public
    mutating
    func decreaseLevel()
    {
        currentLevel -= (currentLevel > 0 ? 1 : 0)
    }
}

//---

postfix operator ++

public
postfix func ++ (indentation: inout Indentation)
{
    indentation.increaseLevel()
}

//---

postfix operator --

public
postfix func -- (indentation: inout Indentation)
{
    indentation.decreaseLevel()
}

//---

//public
//func indent(
//    with indentation: inout Indentation,
//    body: (inout Indentation) -> Void
//    )
//{
//    indentation++
//
//    //---
//
//    var innerIndentation = indentation
//
//    body(&innerIndentation)
//
//    // inside 'body' the 'innerIndentation' should be
//    // either not modified at all or have equal number of
//    // increases and decreases of indetnation level,
//    // so that it returns equal to 'indentation'
//
//    if
//        indentation != innerIndentation
//    {
//        // since this code is NOT supposed to go
//        // into production apps at all, it's okay to
//        // just crash with fatal error
//
//        fatalError("Unbalanced indentation detected!")
//    }
//
//    //---
//
//    indentation--
//}
