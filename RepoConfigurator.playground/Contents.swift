import XCERepoConfigurator

//---

let companyName = "XCEssentials"
let productName = "RepoConfigurator"
let projectName = productName

let swiftVersion = "4.2"

let repoFolder = PathPrefix
    .iCloudDrive
    .appendingPathComponent(
        "Dev/\(companyName)"
    )
    .appendingPathComponent(
        productName
    )

let configResourcesFolder = repoFolder
    .appendingPathComponent(
        "\(productName).playground/Resources"
    )

let authorName = "Maxim Khatskevich"

let depTarget: DeploymentTarget = (.macOS, "10.13")

let fastlaneFolder = repoFolder
    .appendingPathComponent(
        Defaults.pathToFastlaneFolder
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
            .staticShieldsBadge(
                "Xcode",
                status: "required",
                color: "lightgray",
                title: "Requires Xcode",
                link: "https://developer.apple.com/xcode/"
            ),
            .writtenInSwiftBadge(
                version: swiftVersion
            )
        ],
        ExternalFile.load(
            from: configResourcesFolder.appendingPathComponent("BaseReadMe.md")
        )
    )
    .prepare(
        targetFolder: repoFolder,
        removeRepeatingEmptyLines: false
    )

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

try? readme
    .writeToFileSystem()

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
