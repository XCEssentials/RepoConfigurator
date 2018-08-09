import RepoConfigurator

//---

let product = (
    name: "RepoConfigurator",
    summary: "Xcode project repo configuration in Swift."
)

let company = (
    name: "XCEssentials",
    identifier: "com.XCEssentials",
    prefix: "XCE"
)

let repoFolder = PathPrefix
    .iCloudDrive
    .appendingPathComponent(
        "Dev"
    )
    .appendingPathComponent(
        company.name
    )
    .appendingPathComponent(
        product.name
    )

let author = (
    name: "Maxim Khatskevich",
    email: "maxim@khatskevi.ch"
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
        copyrightEntity: "\(company.name) Inc."
    )
    .prepare(
        targetFolder: repoFolder
    )

//---

// let depTarget: DeploymentTarget = (.macOS, "10.13")

let fastlaneFolder = repoFolder
    .appendingPathComponent(
        Defaults.pathToFastlaneFolder
    )

//---

//let fastfile = Fastlane
//    .Fastfile
//    .madeOf(
//        .defaultHeader,
//        .fastlaneVersion(
//            Defaults.fastlaneVersion
//        ),
//        .beforeRelease(
//            projectName: product.name,
//            cocoaPodsModuleName: nil
//        )
//    )
//    .prepare(
//        targetFolder: fastlaneFolder
//    )

//
