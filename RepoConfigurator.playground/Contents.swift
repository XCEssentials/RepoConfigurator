import Files

import XCERepoConfigurator

//---

let companyName = "XCEssentials"
let productName = "RepoConfigurator"
let projectName = productName

let swiftVersion = "4.2"

let repoFolder = try! Folder
    .iCloudDrive!
    .subfolder(
        named: "Dev"
    )
    .subfolder(
        named: companyName
    )
    .subfolder(
        named: productName
    )

let baseReadMe = try! repoFolder
    .subfolder(
        named: "Docs"
    )
    .file(
        named: "BaseReadMe.md"
    )

let authorName = "Maxim Khatskevich"

let depTarget: DeploymentTarget = (.macOS, "10.13")

let fastlaneFolderPath = repoFolder
    .path
    .appending(
        "\(Defaults.pathToFastlaneFolder)"
    )

//---

let readme = try ReadMe
    .openSourceProduct(
        header: [
            .gitHubLicenseBadge(
                account: companyName,
                repo: productName
            ),
            .gitHubTagBadge(
                account: companyName,
                repo: productName
            ),
            .carthageCompatibleBadge(),
            .swiftPMCompatibleBadge(),
            .writtenInSwiftBadge(
                version: swiftVersion
            )
        ],
        baseReadMe.readAsString()
    )
    .prepare(
        targetFolder: repoFolder.path,
        removeRepeatingEmptyLines: false
    )

let gitignore = Git
    .RepoIgnore
    .framework()
    .prepare(
        targetFolder: repoFolder.path
    )

let swiftLint = SwiftLint
    .standard()
    .prepare(
        targetFolder: repoFolder.path
    )

let license = License
    .MIT(
        copyrightYear: 2018,
        copyrightEntity: authorName
    )
    .prepare(
        targetFolder: repoFolder.path
    )

let fastfile = Fastlane
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
        targetFolder: fastlaneFolderPath
    )

let gitHubPagesConfig = GitHub
    .PagesConfig()
    .prepare(
        targetFolder: repoFolder.path
    )

// MARK: - Actually write repo configuration files

do
{
    try readme
        .writeToFileSystem()

    try gitignore
        .writeToFileSystem()

    try swiftLint
        .writeToFileSystem()

    try license
        .writeToFileSystem()

    try fastfile
        .writeToFileSystem()

    try gitHubPagesConfig
        .writeToFileSystem()
}
catch
{
    print(error)
}
