// swift-tools-version:4.2
// Managed by ice

import PackageDescription

let package = Package(
    name: "XCERepoConfigurator",
    products: [
        .library(name: "XCERepoConfigurator", targets: ["XCERepoConfigurator"]),
    ],
    dependencies: [
        .package(url: "https://github.com/JohnSundell/ShellOut", from: "2.1.0"),
        .package(url: "https://github.com/nvzqz/FileKit", from: "5.2.0"),
    ],
    targets: [
        .target(name: "XCERepoConfigurator", dependencies: ["ShellOut", "FileKit"], path: "./Sources/RepoConfigurator"),
        .testTarget(name: "RepoConfiguratorTests", dependencies: ["XCERepoConfigurator"]),
    ],
    swiftLanguageVersions: [.v4, .v4_2]
)
