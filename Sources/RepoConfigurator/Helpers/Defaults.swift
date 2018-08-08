import Foundation

//---

public
enum Defaults
{
    public
    static
    let initialVersionString: VersionString = "0.1.0"

    public
    static
    let initialBuildNumber: BuildNumber = 0

    public
    static
    var copyrightYear: UInt
    {
        // current year
        return UInt(Calendar.current.component(.year, from: Date()))
    }

    public
    static
    let specVariable: String = "s"

    public
    static
    let pathToInfoPlistsFolder: String = "Info"

    public
    static
    let pathToSourcesFolder: String = "Sources"

    public
    static
    let tstSuffix = "Tests"

    public
    static
    let podsFromSpec: String = "podspec"
}
