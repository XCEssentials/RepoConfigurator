import XCERepoConfigurator

//---

let productName = "RepoConfigurator"
let projectName = productName

let repoFolder = PathPrefix
    .iCloudDrive
    .appendingPathComponent(
        "Dev/XCEssentials"
    )
    .appendingPathComponent(
        productName
    )

let authorName = "Maxim Khatskevich"

let depTarget: DeploymentTarget = (.macOS, "10.13")

let fastlaneFolder = repoFolder
    .appendingPathComponent(
        Defaults.pathToFastlaneFolder
)

//---

let gitignore = Git
    .RepoIgnore
    .framework()
    .prepare(
        targetFolder: repoFolder
    )

let swiftLint = SwiftLint
    .init(
        exclude: [
            "Templates"
        ]
    )
    .prepare(
        targetFolder: repoFolder
    )

let license = License
    .MIT(
        copyrightYear: 2018,
        copyrightEntity: authorName
    )
    .prepare(
        targetFolder: repoFolder
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
        targetFolder: fastlaneFolder
    )

let gitHubPagesConfig = GitHub
    .PagesConfig()
    .prepare(
        targetFolder: repoFolder
    )

// MARK: - Actually write repo configuration files

try? gitignore
    .writeToFileSystem()

try? swiftLint
    .writeToFileSystem()

try? license
    .writeToFileSystem()

try? fastfile
    .writeToFileSystem()

try? gitHubPagesConfig
    .writeToFileSystem()
