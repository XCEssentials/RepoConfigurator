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
    // MARK: Type level members

    public
    typealias Snapshot = String

    // MARK: Instance level members

    public
    let singleLevel: String

    public private(set)
    var currentLevel = 0

    public
    var rendered: String
    {
        return .init(repeating: singleLevel, count: currentLevel)
    }

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

    public
    func nest(
        body: () throws -> Void
        ) rethrows
    {
        self.increaseLevel()

        //---

        try body()

        //---

        self.decreaseLevel()
    }

    public
    func nestIf(
        _ condition: Bool,
        body: () throws -> Void
        ) rethrows
    {
        self.increaseLevel()

        //---

        if
            condition
        {
            try body()
        }

        //---

        self.decreaseLevel()
    }

    public
    func nestIfUnwrap<T>(
        _ optionalValue: T?,
        body: (T) throws -> Void
        ) rethrows
    {
        self.increaseLevel()

        //---

        if
            let unwrappedValue = optionalValue
        {
            try body(unwrappedValue)
        }

        //---

        self.decreaseLevel()
    }

    // MARK: Initializers

    public
    init(
        _ singleLevel: String = Defaults.standardIndentation
        )
    {
        self.singleLevel = singleLevel
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
