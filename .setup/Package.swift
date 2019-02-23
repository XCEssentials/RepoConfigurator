// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "RepoConfiguratorSetup",
    products: [
        .executable(
            name: "RepoConfiguratorSetup",
            targets: ["RepoConfiguratorSetup"]
        )
    ],
    dependencies: [
        .package(path: "./../")
    ],
    targets: [
        .target(
            name: "RepoConfiguratorSetup",
            dependencies: ["XCERepoConfigurator"],
            path: "./",
            sources: ["main.swift"]
        )
    ],
    swiftLanguageVersions: [
        .v4,
        .v4_2
    ]
)
