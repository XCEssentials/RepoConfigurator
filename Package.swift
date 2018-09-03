// swift-tools-version:4.0
// Managed by ice

import PackageDescription

let package = Package(
    name: "XCERepoConfigurator",
    products: [
        .library(name: "XCERepoConfigurator", targets: ["RepoConfigurator"]),
    ],
    targets: [
        .target(name: "RepoConfigurator", dependencies: []),
        .testTarget(name: "RepoConfiguratorTests", dependencies: ["RepoConfigurator"]),
    ]
)
