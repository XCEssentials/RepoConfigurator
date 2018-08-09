public
protocol WidelyUsedLicense: FixedNameTextFile
{
    static
    var licenseType: String { get }
}

//---

public
extension WidelyUsedLicense
{
    static
    var licenseType: String
    {
        // by default return intrinsic license type based on type name

        return String
            .init(describing: self)
            .components(
                separatedBy: .whitespacesAndNewlines
            )
            .first
            ??
            ""
    }

    var licenseType: String
    {
        return Self.licenseType
    }

    static
    var fileName: String
    {
        return "LICENSE"
    }
}
