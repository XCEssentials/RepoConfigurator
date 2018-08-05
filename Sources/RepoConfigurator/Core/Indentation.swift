public
struct Indentation
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
