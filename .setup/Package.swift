// swift-tools-version:5.3

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
        .package(name: "XCERepoConfigurator", path: "./../")
    ],
    targets: [
        .target(
            name: "RepoConfiguratorSetup",
            dependencies: ["XCERepoConfigurator"],
            path: "Setup"
        )
    ]
)
