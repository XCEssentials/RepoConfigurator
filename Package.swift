// swift-tools-version:4.2
// Managed by ice

import PackageDescription

let package = Package(
    name: "XCERepoConfigurator",
    products: [
        .library(name: "XCERepoConfigurator", targets: ["XCERepoConfigurator"])
    ],
    targets: [
        .target(
            name: "XCERepoConfigurator",
            dependencies: [
                // none
            ],
            path: "./Sources/RepoConfigurator"
        ),
        .testTarget(
            name: "RepoConfiguratorTests",
            dependencies: [
                "XCERepoConfigurator"
            ]
        )
    ],
    swiftLanguageVersions: [.v4, .v4_2]
)
