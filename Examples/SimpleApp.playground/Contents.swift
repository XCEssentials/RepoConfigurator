import XCERepoConfigurator

//---

// one item for main target, and one - for unit tests
typealias PerTarget<T> = (main: T, tst: T)

//---

let productName = "SimpleApp"

let company = (
    name: "SomeCoolCompany",
    identifier: "com.SomeCoolCompany",
    prefix: "SCC",
    developmentTeamId: "ABCXYZ123"
)

let repoFolder = PathPrefix
    .iCloudDrive
    .appendingPathComponent(
        "Dev/XCEssentials"
    )
    .appendingPathComponent(
        "RepoConfigurator/Examples"  // !!!
    )
    .appendingPathComponent(
        productName
    )

let tstSuffix = Defaults.tstSuffix

let targetName: PerTarget = (
    productName,
    productName + tstSuffix
)

let commonInfoPlistsPath = Defaults
    .pathToInfoPlistsFolder

let infoPlistsFolder = repoFolder
    .appendingPathComponent(
        commonInfoPlistsPath
    )

let depTarget: DeploymentTarget = (.iOS, "11.0")

let swiftVersion: VersionString = "4.2"

let commonSourcesPath = Defaults.pathToSourcesFolder

let sourcesPath: PerTarget = (
    commonSourcesPath + "/" + targetName.main,
    commonSourcesPath + "/" + targetName.tst
)

let sourcesFolder: PerTarget = (
    repoFolder
        .appendingPathComponent(
            sourcesPath.main
    ),
    repoFolder
        .appendingPathComponent(
            sourcesPath.tst
    )
)

let bundleId: PerTarget = (
    company.identifier + "." + targetName.main,
    company.identifier + "." + targetName.tst
)

//---

let gitignore = Git
    .RepoIgnore
    .app()
    .prepare(
        targetFolder: repoFolder
    )

let swiftLint = SwiftLint
    .init()
    .prepare(
        targetFolder: repoFolder
    )

let info: PerTarget = (
    Xcode
        .Target
        .InfoPlist(
            for: .app,
            preset: .iOS
        )
        .prepare(
            name: targetName.main + ".plist",
            targetFolder: infoPlistsFolder
        ),
    Xcode
        .Target
        .InfoPlist(
            for: .tests,
            preset: nil
        )
        .prepare(
            name: targetName.tst + ".plist",
            targetFolder: infoPlistsFolder
        )
)

let emptyFile: PerTarget = (
    CustomTextFile
        .init()
        .prepare(
            name: targetName.main + ".swift",
            targetFolder: sourcesFolder.main
        ),
    CustomTextFile
        .init()
        .prepare(
            name: targetName.tst + ".swift",
            targetFolder: sourcesFolder.tst
        )
)

//---

let infoPlistsPath: PerTarget = (
    commonInfoPlistsPath + "/" + info.main.name,
    commonInfoPlistsPath + "/" + info.tst.name
)

//---

let project = Struct
    .Spec(productName){

        project in

        //---

        project.buildSettings.base.override(

            "DEVELOPMENT_TEAM" <<< company.developmentTeamId,
            "SWIFT_VERSION" <<< swiftVersion,

            "IPHONEOS_DEPLOYMENT_TARGET" <<< depTarget.minimumVersion
        )

        //---

        project.targets(

            Mobile.App(targetName.main){

                app in

                //---

                app.include(sourcesPath.main)

                //---

                app.buildSettings.base.override(

                    "DEVELOPMENT_TEAM" <<< "$(inherited)",
                    "INFOPLIST_FILE" <<< infoPlistsPath.main,
                    "PRODUCT_BUNDLE_IDENTIFIER" <<< bundleId.main,

                    //--- iOS related:

                    "IPHONEOS_DEPLOYMENT_TARGET" <<< depTarget.minimumVersion,
                    "TARGETED_DEVICE_FAMILY" <<< DeviceFamily.iOS.phone
                )

                //---

                app.addUnitTests(targetName.tst) {

                    appTests in

                    //---

                    appTests.include(sourcesPath.tst)

                    //---

                    appTests.buildSettings.base.override(

                        "INFOPLIST_FILE" <<< infoPlistsPath.tst,
                        "PRODUCT_BUNDLE_IDENTIFIER" <<< bundleId.tst,

                        "IPHONEOS_DEPLOYMENT_TARGET" <<< depTarget.minimumVersion
                    )
                }
            }
        )
    }
    .prepare(
        targetFolder: repoFolder
    )

let podfile = CocoaPods
    .Podfile(
        workspaceName: productName,
        targets: [
            .target(
                targetName.main,
                deploymentTarget: depTarget,
                pods: [

                    // add pods here...
                ]
            )
        ]
    )
    .prepare(
        targetFolder: repoFolder
    )

// https://docs.fastlane.tools/getting-started/ios/setup/#use-a-gemfile
//let gemfile = Bundler
//    .Gemfile()
//    .prepare(
//        targetFolder: repoFolder
//    )

//---

let fastlaneFolder = repoFolder
    .appendingPathComponent(
        Defaults.pathToFastlaneFolder
    )

let schemeStaging = targetName.main

//---

let fastfile = Fastlane
    .Fastfile
    .app(
        productName: productName
    )
    .prepare(
        targetFolder: fastlaneFolder
    )

// MARK: - Actually write repo configuration files

try? gitignore
    .writeToFileSystem()

try? swiftLint
    .writeToFileSystem()

try? info
    .main
    .writeToFileSystem(ifFileExists: .doNotWrite) // write ONCE!

try? info
    .tst
    .writeToFileSystem(ifFileExists: .doNotWrite) // write ONCE!

try? emptyFile
    .main
    .writeToFileSystem(ifFileExists: .doNotWrite) // write ONCE!

try? emptyFile
    .tst
    .writeToFileSystem(ifFileExists: .doNotWrite) // write ONCE!

try? project
    .writeToFileSystem()

try? podfile
    .writeToFileSystem()

//try? gemfile
//    .writeToFileSystem()

try? fastfile
    .writeToFileSystem()
