// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "XCERepoConfigurator",
    products: [
        .library(
            name: "XCERepoConfigurator",
            targets: [
                "XCERepoConfigurator"
            ]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/kylef/PathKit", from: "1.0.0"),
        .package(url: "https://github.com/nschum/SwiftHamcrest", .exact("2.1.1")),
        .package(url: "https://github.com/mxcl/Version.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "XCERepoConfigurator",
            dependencies: [
                "Version",
                "PathKit"
            ],
            path: "Sources/Core"
        ),
        .testTarget(
            name: "XCERepoConfiguratorAllTests",
            dependencies: [
                "XCERepoConfigurator",
                "Version",
                "SwiftHamcrest"
            ],
            path: "Tests/AllTests"
        ),
    ],
    swiftLanguageVersions: [.v4, .v4_2]
)