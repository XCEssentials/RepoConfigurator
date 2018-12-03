public
extension RawRepresentable
    where
    RawValue == String
{
    var title: String
    {
        return (rawValue.first.map(String.init)?.uppercased() ?? "")
            + rawValue.dropFirst()
    }
}
