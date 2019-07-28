// swift-tools-version:5.0

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
        .package(url: "https://github.com/mxcl/Version.git", from: "1.0.0"),
        .package(url: "https://github.com/nschum/SwiftHamcrest", from: "2.2.1")
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
    swiftLanguageVersions: [.v5]
)