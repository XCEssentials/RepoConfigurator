import FileKit

import XCERepoConfigurator

// MARK: - PRE-script invocation output

print("\n")
print("--- BEGIN of '\(Executable.name)' script ---")

// MARK: -

// MARK: Parameters

 Spec.BuildSettings.swiftVersion.value = "4.2"

let remoteRepo = try Spec.RemoteRepo()

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

let targets = (
    main: try Spec.Target(
        cocoaPod.product.name, // library name with prefix!
        project: project,
        platform: project.deploymentTargets.asPairs()[0].platform,
        bundleIdInfo: .autoWithCompany(company),
        provisioningProfiles: [:],
        sourcesLocation: Spec.Locations.sources + project.name,
        packageType: .framework
    ),
    none: ()
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
        gem '\(CocoaPods.gemName)', '1.6.0.beta.2'
        gem '\(CocoaPods.Rome.gemName)', '~>1.0.1'
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

        # \(project.name)

        """
    )
    .prepare(
        removeRepeatingEmptyLines: false
    )
    .writeToFileSystem(
        ifFileExists: .skip
    )

// MARK: Write - SwiftLint

try SwiftLint
    .standard()
    .prepare()
    .writeToFileSystem()

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
        platform :osx, '\(project.deploymentTargets.asPairs()[0].minimumVersion)'

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
                targetNames: [targets.main.name],
                params:[
                    """
                    --path "\(targets.main.sourcesLocation)"
                    """
                ]
            )
        },
        endingEntries: [
            
            """
            cocoapods # https://docs.fastlane.tools/actions/cocoapods/
            """,

            """
            # NOTE: Origin path MUST be absolute in order the symlink to work properly!
            sh 'cd ./.. && \(Utils.symLinkCmd(("$PWD" + SwiftLint.relativeLocation).rawValue, targets.main.linterCfgLocation.rawValue))'
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
            *.xcodeproj

            # derived files generated by '.setup' script
            \(DummyFile.relativeLocation.rawValue)
            
            Examples/**/Package.resolved
            """
        ]
    )
    .prepare()
    .writeToFileSystem()

// MARK: - POST-script invocation output

print("--- END of '\(Executable.name)' script ---")
