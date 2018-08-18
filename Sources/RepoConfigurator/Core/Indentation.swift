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
class Indentation: Equatable
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
    lazy
    var rendered: String = .init(repeating: singleLevel, count: currentLevel)

    public
    func increaseLevel()
    {
        currentLevel += 1
    }

    public
    func decreaseLevel()
    {
        currentLevel -= (currentLevel > 0 ? 1 : 0)
    }
}

//---

public
func == (lhs: Indentation, rhs: Indentation) -> Bool
{
    return (lhs.singleLevel == rhs.singleLevel)
        && (lhs.currentLevel == rhs.currentLevel)
}

//---

postfix operator ++

public
postfix func ++ (indentation: Indentation)
{
    indentation.increaseLevel()
}

//---

postfix operator --

public
postfix func -- (indentation: Indentation)
{
    indentation.decreaseLevel()
}

//---

public
func indent(
    with indentation: Indentation,
    body: () -> Void
    )
{
    indentation++

    //---

    body()

    //---

    indentation--
}
