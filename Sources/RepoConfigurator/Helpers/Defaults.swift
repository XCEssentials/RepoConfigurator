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
    let specVariable = "s"

    public
    static
    let pathToInfoPlistsFolder = "Info"

    public
    static
    let pathToSourcesFolder = "Sources"

    public
    static
    let tstSuffix = "Tests"

    public
    static
    let podsFromSpec = "podspec"

    public
    static
    let pathToFastlaneFolder = "fastlane" // in LOWER case!

    public
    static
    let fastlaneVersion: VersionString = "2.100.0"

    public
    static
    let archivesExportPath = ".archives"
}
