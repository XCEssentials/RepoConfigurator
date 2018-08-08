public
enum CocoaPods {}

//---

public
extension OSIdentifier
{
    var cocoaPodsId: String
    {
        switch self
        {
        case .iOS:
            return "ios"

        case .watchOS:
            return "watchos"

        case .tvOS:
            return "tvos"

        case .macOS:
            return "osx"
        }
    }
}

//---

public
extension WidelyUsedLicense
{
    var cocoaPodsLicenseSummary: CocoaPods.Podspec.License
    {
        return (
            type: licenseType,
            fileName
        )
    }
}
