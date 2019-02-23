// swift-tools-version:4.2
// Managed by ice

import PackageDescription

let package = Package(
    name: "MyAppSetup",
    dependencies: [
        .package(url: "https://github.com/nvzqz/FileKit", from: "5.2.0"),
        //.package(url: "https://github.com/XCEssentials/RepoConfigurator", from: "1.21.0"),
        .package(path: "./../../../../")
    ],
    targets: [
        .target(
            name: "MyAppSetup",
            dependencies: ["XCERepoConfigurator", "FileKit"],
            path: ".",
            sources: ["main.swift"]
        )
    ]
)
