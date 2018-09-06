// swift-tools-version:4.2
// Managed by ice

import PackageDescription

let package = Package(
    name: "XCERepoConfigurator",
    products: [
        .library(name: "XCERepoConfigurator", targets: ["RepoConfigurator"]),
    ],
    dependencies: [
        .package(url: "https://github.com/JohnSundell/Files", from: "2.2.1"),
    ],
    targets: [
        .target(name: "RepoConfigurator", dependencies: ["Files"], path: "./Sources/RepoConfigurator"),
        .testTarget(name: "RepoConfiguratorTests", dependencies: ["RepoConfigurator"]),
    ],
    swiftLanguageVersions: [.v4, .v4_2]
)
