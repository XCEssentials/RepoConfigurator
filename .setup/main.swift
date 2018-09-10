import Foundation

import Files

import XCERepoConfigurator

//---

print("\n")
print("--- BEGIN of '\(Bundle.main.executableURL?.pathComponents.last ?? "?")' script ---")

//---

guard
    let repoFolder = Folder.current.parent
else
{
    preconditionFailure("❌ Expected to be in a subfolder, one level deep from root!")
}

print("✅ Repo folder: \(repoFolder.path)")

//---

guard
    let companyName = repoFolder.parent?.name
else
{
    preconditionFailure("❌ Expected to be two levels deep from a company-named folder!")
}

print("✅ Company name: \(companyName)")

//---

let productName = repoFolder.name

print("✅ Product name (without company prefix): \(productName)")

//---

let projectName = productName

let swiftVersion = "4.2"

let authorName = "Maxim Khatskevich"

let depTarget: DeploymentTarget = (.macOS, "10.13")

//---

guard
    let fastlaneFolder = try? repoFolder
        .createSubfolderIfNeeded(withName: Defaults.pathToFastlaneFolder)
else
{
    preconditionFailure("❌ Failed to establish Fastlane base folder.")
}

print("✅ Fastlane folder: ./\(fastlaneFolder.name)")

//---

do
{
    print("Writing '\(ReadMe.fileName)'")

    let readMe = try ReadMe()
        .addGitHubLicenseBadge(
            account: companyName,
            repo: productName
        )
        .addGitHubTagBadge(
            account: companyName,
            repo: productName
        )
        .addCarthageCompatibleBadge()
        .addSwiftPMCompatibleBadge()
        .addWrittenInSwiftBadge(
            version: swiftVersion
        )
        .add(
            """

            # \(productName)

            """
        )
        .prepare(
            targetFolder: repoFolder.path,
            removeRepeatingEmptyLines: false
        )
        .writeToFileSystem(
            ifFileExists: .skip
        )

    if
        !readMe
    {
        print("ⓘ NOTE: skipped ReadMe, because it already exists.")
    }

    //---

    print("Writing '\(Git.RepoIgnore.fileName)'")

    try Git
        .RepoIgnore
        .framework(
            otherEntries: [
                "*.xcodeproj"
            ]
        )
        .prepare(
            targetFolder: repoFolder.path
        )
        .writeToFileSystem()

    //---

    print("Writing '\(SwiftLint.fileName)'")

    try SwiftLint
        .standard()
        .prepare(
            targetFolder: repoFolder.path
        )
        .writeToFileSystem()

    //---

    print("Writing '\(License.MIT.fileName)'")

    try License
        .MIT(
            copyrightYear: 2018,
            copyrightEntity: authorName
        )
        .prepare(
            targetFolder: repoFolder.path
        )
        .writeToFileSystem()

    //---

    print("Writing '\(Fastlane.Fastfile.fileName)'")

    try Fastlane
        .Fastfile
        .custom(
            predefinedSections: [
                .defaultHeader(),
                .beforeRelease(
                    projectName: projectName,
                    cocoaPodsModuleName: nil
                )
            ]
        )
        .prepare(
            targetFolder: fastlaneFolder.path
        )
        .writeToFileSystem()

    //---

    print("Writing '\(GitHub.PagesConfig.fileName)'")

    try GitHub
        .PagesConfig()
        .prepare(
            targetFolder: repoFolder.path
        )
        .writeToFileSystem()
}
catch
{
    print(error)
}

//---

print("--- END of '\(Bundle.main.executableURL?.pathComponents.last ?? "?")' script ---")
