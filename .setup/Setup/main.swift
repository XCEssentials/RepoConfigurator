import PathKit

import XCERepoConfigurator

// MARK: - PRE-script invocation output

print("\n")
print("--- BEGIN of '\(Executable.name)' script ---")

// MARK: -

// MARK: Parameters

Spec.BuildSettings.swiftVersion.value = "5.0"

let localRepo = try Spec.LocalRepo.current()

let remoteRepo = try Spec.RemoteRepo(
    accountName: localRepo.context,
    name: localRepo.name
)

let travisCI = (
    address: "https://travis-ci.com/\(remoteRepo.accountName)/\(remoteRepo.name)",
    branch: "master"
)

let company = try Spec.Company(
    prefix: "XCE",
    identifier: "com.\(remoteRepo.accountName)"
)

let project = (
    name: remoteRepo.name,
    summary: "Generate repo config files using Swift and Xcode.",
    copyrightYear: 2018
)

let productName = company.prefix + project.name

let authors = [
    ("Maxim Khatskevich", "maxim@khatskevi.ch")
]

// swift-package-manager
let desktop = ".macOS(.v10_11)" // DeploymentTarget = (.macOS, "10.11")

typealias PerSubSpec<T> = (
    core: T,
    tests: T
)

let subSpecs: PerSubSpec = (
    "Core",
    "AllTests"
)

let targetNames: PerSubSpec = (
    productName,
    productName + subSpecs.tests
)

let sourcesLocations: PerSubSpec = (
    Spec.Locations.sources + subSpecs.core,
    Spec.Locations.tests + subSpecs.tests
)

// MARK: Parameters - Summary

remoteRepo.report()
company.report()

// MARK: -

// MARK: Write - ReadMe

try ReadMe()
    .addGitHubLicenseBadge(
        account: company.name,
        repo: project.name
    )
    .addGitHubTagBadge(
        account: company.name,
        repo: project.name
    )
    .addSwiftPMCompatibleBadge()
    .addWrittenInSwiftBadge(
        version: Spec.BuildSettings.swiftVersion.value
    )
    .addStaticShieldsBadge(
        "platforms",
        status: "macOS",
        color: "blue",
        title: "Supported platforms",
        link: "Package.swift"
    )
    .add("""
        [![Build Status](\(travisCI.address).svg?branch=\(travisCI.branch))](\(travisCI.address))
        """
    )
    .add("""

        # \(project.name)

        \(project.summary)

        """
    )
    .prepare(
        removeRepeatingEmptyLines: false
    )
    .writeToFileSystem(
        ifFileExists: .skip
    )

// MARK: Write - License

try License
    .MIT(
        copyrightYear: UInt(project.copyrightYear),
        copyrightEntity: authors.map{ $0.0 }.joined(separator: ", ")
    )
    .prepare()
    .writeToFileSystem()

// MARK: Write - GitHub - PagesConfig

try GitHub
    .PagesConfig()
    .prepare()
    .writeToFileSystem()

// MARK: Write - Git - .gitignore

try Git
    .RepoIgnore()
    .addMacOSSection()
    .addCocoaSection()
    .addSwiftPackageManagerSection(ignoreSources: true)
    .add(
        """
        # we don't need to store project file,
        # as we generate it on-demand
        *.\(Xcode.Project.extension)
        """
    )
    .prepare()
    .writeToFileSystem()

// MARK: Write - Package.swift

try CustomTextFile("""
    // swift-tools-version:\(Spec.BuildSettings.swiftVersion.value)

    import PackageDescription

    let package = Package(
        name: "\(productName)",
        platforms: [
            \(desktop),
        ],
        products: [
            .library(
                name: "\(productName)",
                targets: [
                    "\(targetNames.core)"
                ]
            )
        ],
        dependencies: [
            .package(url: "https://github.com/kylef/PathKit", from: "1.0.0"),
            .package(url: "https://github.com/mxcl/Version.git", from: "1.0.0"),
            .package(url: "https://github.com/JohnSundell/ShellOut.git", from: "2.0.0"),
            .package(url: "https://github.com/nschum/SwiftHamcrest", from: "2.2.1")
        ],
        targets: [
            .target(
                name: "\(targetNames.core)",
                dependencies: [
                    "Version",
                    "PathKit",
                    "ShellOut"
                ],
                path: "\(sourcesLocations.core)"
            ),
            .testTarget(
                name: "\(targetNames.tests)",
                dependencies: [
                    "\(targetNames.core)",
                    "Version",
                    "SwiftHamcrest"
                ],
                path: "\(sourcesLocations.tests)"
            ),
        ]
    )
    """
    )
    .prepare(
        at: ["Package.swift"]
    )
    .writeToFileSystem()

// MARK: - POST-script invocation output

print("--- END of '\(Executable.name)' script ---")
