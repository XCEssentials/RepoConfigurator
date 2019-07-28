// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "RepoConfiguratorSetup",
    platforms: [
        .macOS(.v10_11),
    ],
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
        .v5
    ]
)
