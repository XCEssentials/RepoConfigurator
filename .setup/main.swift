import PathKit

import XCERepoConfigurator

// MARK: - PRE-script invocation output

print("\n")
print("--- BEGIN of '\(Executable.name)' script ---")

// MARK: -

// MARK: Parameters

Spec.BuildSettings.swiftVersion.value = "4.2"
let swiftLanguageVersionsForSPM = "[.v4, .v4_2]"

let remoteRepo = try Spec.RemoteRepo()

let travis = (
    server: "https://travis-ci.com",
    account: remoteRepo.accountName,
    repo: remoteRepo.name,
    branch: "master"
)

let company = try Spec.Company(
    prefix: "XCE",
    identifier: "com.\(remoteRepo.accountName)"
)

let project = try Spec.Project(
    summary: "Generate repo config files using Swift and Xcode.",
    copyrightYear: 2018,
    deploymentTargets: [
        .macOS : "10.11"
    ]
)

let cocoaPod = try Spec.CocoaPod(
    companyInfo: .from(company),
    productInfo: .from(project),
    authors: [
        ("Maxim Khatskevich", "maxim@khatskevi.ch")
    ]
)

let desktop = project.deploymentTargets[0]

let subSpecs = (
    core: Spec.CocoaPod.SubSpec(
        "", // will pe extended with product name prefix
        sourcesLocation: Spec.Locations.sources + ["Core"]
    ),
    tests: Spec.CocoaPod.SubSpec.tests()
)

let allSubspecs = try Spec
    .CocoaPod
    .SubSpec
    .extractAll(from: subSpecs)

let targetsSPM = (
    core: (
        productName: cocoaPod.product.name,
        name: cocoaPod.product.name + subSpecs.core.name
    ),
    allTests: (
        name: cocoaPod.product.name + subSpecs.tests.name,
        none: ()
    )
)

// MARK: Parameters - Summary

remoteRepo.report()
company.report()
project.report()
cocoaPod.report()

// MARK: -

// MARK: Write - Bundler - Gemfile

try Bundler
    .Gemfile(
        basicFastlane: true,
        """
        gem '\(CocoaPods.gemName)'
        gem '\(CocoaPods.Rome.gemName)'
        """
    )
    .prepare()
    .writeToFileSystem()

// MARK: Write - ReadMe

try ReadMe()
    .addGitHubLicenseBadge(
        account: company.name,
        repo: project.name
    )
    .addGitHubTagBadge(
        account: company.name,
        repo: project.name
    )
    .addSwiftPMCompatibleBadge()
    .addCarthageCompatibleBadge()
    .addWrittenInSwiftBadge(
        version: Spec.BuildSettings.swiftVersion.value
    )
    .add("""
        [![Build Status](\(travis.server)/\(travis.account)/\(travis.repo).svg?branch=\(travis.branch))](\(travis.server)/\(travis.account)/\(travis.repo))
        """
    )
    .add("""

        # \(project.name)

        """
    )
    .prepare(
        removeRepeatingEmptyLines: false
    )
    .writeToFileSystem(
        ifFileExists: .skip // ONLY write if missing!
    )

// MARK: Write - SwiftLint

try allSubspecs
    .filter{ !$0.tests }
    .map{ $0.linterCfgLocation }
    .forEach{
        
        try SwiftLint
            .standard()
            .prepare(
                at: $0
            )
            .writeToFileSystem()
    }

// MARK: Write - License

try License
    .MIT(
        copyrightYear: project.copyrightYear,
        copyrightEntity: cocoaPod.authors[0].name
    )
    .prepare()
    .writeToFileSystem()

// MARK: Write - CocoaPods - Podfile

try CocoaPods
    .Podfile()
    .custom("""
        platform :\(desktop.platform.cocoaPodsId), '\(desktop.minimumVersion)'

        plugin '\(CocoaPods.Rome.gemName)'

        target 'Abstract' do

            pod 'SwiftLint'

        end
        """
    )
    .prepare()
    .writeToFileSystem()

// MARK: Write - Fastlane - Fastfile

try Fastlane
    .Fastfile
    .ForLibrary()
    .defaultHeader()
    .generateProjectViaSwiftPM(
        for: cocoaPod,
        scriptBuildPhases: {
            
            try $0.swiftLint(
                project: [cocoaPod.product.name],
                targetNames: [targetsSPM.core.name],
                params:[
                    """
                    --path "\(subSpecs.core.sourcesLocation)"
                    """
                ]
            )
        },
        endingEntries: [
            
            """
            
            # default initial location for any command
            # is inside 'Fastlane' folder

            sh 'cd ./.. && bundle exec pod install'

            """
        ]
    )
    .prepare()
    .writeToFileSystem()

// MARK: Write - GitHub - PagesConfig

try GitHub
    .PagesConfig()
    .prepare()
    .writeToFileSystem()

// MARK: Write - Git - .gitignore

try Git
    .RepoIgnore
    .framework(
        otherEntries: [
            """
            # we don't need to store any project files,
            # as we generate them on-demand from specs
            *.\(Xcode.Project.extension)
            """
        ]
    )
    .prepare()
    .writeToFileSystem()

// MARK: Write - Package.swift

try CustomTextFile("""
    // swift-tools-version:\(Spec.BuildSettings.swiftVersion.value)

    import PackageDescription

    let package = Package(
        name: "\(cocoaPod.product.name)",
        products: [
            .library(
                name: "\(targetsSPM.core.productName)",
                targets: [
                    "\(targetsSPM.core.name)"
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
                name: "\(targetsSPM.core.name)",
                dependencies: [
                    "Version",
                    "PathKit"
                ],
                path: "\(subSpecs.core.sourcesLocation)"
            ),
            .testTarget(
                name: "\(targetsSPM.allTests.name)",
                dependencies: [
                    "\(targetsSPM.core.name)",
                    "Version",
                    "SwiftHamcrest"
                ],
                path: "\(subSpecs.tests.sourcesLocation)"
            ),
        ],
        swiftLanguageVersions: \(swiftLanguageVersionsForSPM)
    )
    """
    )
    .prepare(at: ["Package.swift"])
    .writeToFileSystem()

// MARK: Write - .travis.yml

try CustomTextFile("""
    # https://docs.travis-ci.com/user/customizing-the-build/
    # https://docs.travis-ci.com/user/job-lifecycle/#the-job-lifecycle
    # https://docs.travis-ci.com/user/languages/objective-c/

    git:
      depth: 3
      submodules: false

    language: objective-c

    osx_image:
      - xcode10.2
      - xcode10.1

    before_install:
     - bundle install --path .vendor/bundle --jobs=3 --retry=3 --deployment
     - bundle exec pod repo update

    install:
     - bundle exec pod install

    before_script:
      # cd ./.setup && swift run && cd ./.. # RUN this manually!
      - bundle exec fastlane generateProjectViaSwiftPM
      - swift --version

    xcode_project: \(cocoaPod.product.name).\(Xcode.Project.extension)
    xcode_scheme: \(cocoaPod.product.name)-Package
    xcode_destination: platform=macOS
    
    """
    )
    .prepare(at: [".travis.yml"])
    .writeToFileSystem()

// MARK: - POST-script invocation output

print("--- END of '\(Executable.name)' script ---")
