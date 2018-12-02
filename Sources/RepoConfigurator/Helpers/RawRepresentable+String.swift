public
extension RawRepresentable
    where
    RawValue == String
{
    var title: String
    {
        return rawValue.capitalized
    }
}
