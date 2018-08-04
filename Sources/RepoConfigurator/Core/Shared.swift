/**
 Version number like '1.2.0'.
 See more details about expected format: https://semver.org/
 */
public
typealias VersionString = String

public
typealias BuildNumber = UInt

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
    let minimumVersion: VersionString
}

//---

public
enum DeviceFamily
{
    public
    enum iOS
    {
        public
        static
        let universal = "1,2"

        public
        static
        let phone = "1" // iPhone and iPod Touch

        public
        static
        let pad   = "2"  // iPad
    }
}

//---

public
typealias KeyValuePair = (key: String, value: Any)

infix operator <<<

public
func <<< (keyName: String, value: Any) -> KeyValuePair
{
    return (keyName, value)
}
