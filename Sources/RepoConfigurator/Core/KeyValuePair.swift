public
typealias KeyValuePair = (key: String, value: Any)

//---

infix operator <<<

public
func <<< (keyName: String, value: Any) -> KeyValuePair
{
    return (keyName, value)
}
