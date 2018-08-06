// internal
extension Struct.Spec
{
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
