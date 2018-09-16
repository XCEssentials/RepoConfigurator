// swift-tools-version:4.2
// Managed by ice

import PackageDescription

let package = Package(
    name: "XCERepoConfigurator",
    products: [
        .library(name: "XCERepoConfigurator", targets: ["XCERepoConfigurator"]),
    ],
    dependencies: [
        .package(url: "https://github.com/JohnSundell/Files", from: "2.2.1"),
    ],
    targets: [
        .target(name: "XCERepoConfigurator", dependencies: ["Files"], path: "./Sources/RepoConfigurator"),
        .testTarget(name: "RepoConfiguratorTests", dependencies: ["XCERepoConfigurator"]),
    ],
    swiftLanguageVersions: [.v4, .v4_2]
)