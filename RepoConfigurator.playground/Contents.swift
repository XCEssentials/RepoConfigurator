import RepoConfigurator

//---

let productName = "RepoConfigurator"

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
    .framework
    .prepare(
        targetFolder: repoFolder
    )

let swiftLint = SwiftLint
    .defaultXCE
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
    .Fastfile(
        .defaultHeader,
        .fastlaneVersion(
            Defaults.fastlaneVersion
        ),
        .beforeRelease(
            projectName: productName,
            cocoaPodsModuleName: nil
        )
    )
    .prepare(
        targetFolder: fastlaneFolder
    )

let podfile = CocoaPods
    .Podfile
    .standard(
        productName: productName,
        deploymentTarget: depTarget,
        pods: [
            "pod 'SwiftLint'"
        ]
    )
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

try? podfile
    .writeToFileSystem()
