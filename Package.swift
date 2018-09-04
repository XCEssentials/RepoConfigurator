// swift-tools-version:4.2
// Managed by ice

import PackageDescription

let package = Package(
    name: "XCERepoConfigurator",
    products: [
        .library(name: "XCERepoConfigurator", targets: ["RepoConfigurator"])
    ],
    targets: [
        .target(
            name: "RepoConfigurator",
            dependencies: [
                // none
            ],
            path: "./Sources/RepoConfigurator"
        ),
        .testTarget(
            name: "RepoConfiguratorTests",
            dependencies: [
                "RepoConfigurator"
            ]
        )
    ],
    swiftLanguageVersions: [.v4, .v4_2]
)
