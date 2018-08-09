import Foundation

//---

public
enum PathPrefix
{
    public
    static
    let root = URL(fileURLWithPath: "/")

    public
    static
    let userHomeDir = FileManager
        .default
        .homeDirectoryForCurrentUser

    public
    static
    let iCloudDrive = try! FileManager //swiftlint:disable:this force_try
        .default
        .url(for: .libraryDirectory,
             in: .userDomainMask,
             appropriateFor: nil,
             create: false)
        .appendingPathComponent("Mobile Documents/com~apple~CloudDocs")
}
