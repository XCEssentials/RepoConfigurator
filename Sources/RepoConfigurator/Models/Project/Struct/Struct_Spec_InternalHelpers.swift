// internal
extension Struct.Spec
{
    static
        func ident(_ idention: Int) -> String
    {
        return Array(repeating: "  ", count: idention).joined()
    }

    static
        func key(_ v: Any) -> String
    {
        return "\(v):"
    }

    static
        func value(_ v: Any) -> String
    {
        return " \"\(v)\""
    }
}

//---

// internal
extension Struct
{
    typealias SpecLine = (idention: Int, line: String)
    typealias RawSpec = [SpecLine]
}

//---

// internal
func <<< (list: inout Struct.RawSpec, element: Struct.SpecLine)
{
    list.append(element)
}

// internal
func <<< (list: inout Struct.RawSpec, elements: Struct.RawSpec)
{
    list.append(contentsOf: elements)
}
