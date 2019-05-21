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
        .package(url: "https://github.com/nschum/SwiftHamcrest", from: "2.1.0"),
        .package(url: "https://github.com/mxcl/Version.git", from: "1.0.0")
    ],
    targets: [
        .target(name: "XCERepoConfigurator", dependencies: ["Version", "FileKit"], path: "./Sources/RepoConfigurator"),
        .testTarget(name: "RepoConfiguratorTests", dependencies: ["XCERepoConfigurator", "Version", "SwiftHamcrest"]),
    ],
    swiftLanguageVersions: [.v4, .v4_2]
)
