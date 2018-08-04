/**
 Version number like '1.2.0'.
 See more details about expected format: https://semver.org/
 */
public
typealias VersionNumber = String

//---

public
enum OSIdentifier: String
{
    case iOS
    case watchOS
    case tvOS
    case macOS
}

//---

public
struct DeploymentTarget
{
    public
    let platform: OSIdentifier

    public
    let minimumVersion: VersionNumber
}
