import RepoConfigurator

//---

// one item for main target, and one - for unit tests
typealias PerTarget<T> = (main: T, tst: T)

//---

let product: CocoaPods.Podspec.Product = (
    name: "SimpleFramework",
    summary: "A simple framework."
)

let company: CocoaPods.Podspec.Company = (
    name: "SomeCoolCompany",
    identifier: "com.SomeCoolCompany",
    prefix: "SCC"
)

let author: CocoaPods.Podspec.Author = (
    name: "John Appleseed",
    email: "john@example.com"
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
        product.name
    )

//---

let gitignore = Git
    .RepoIgnore
    .framework
    .prepare(
        targetFolder: repoFolder
    )

let swiftLint = SwiftLint
    .defaultXCE
    .prepare(
        targetFolder: repoFolder
    )

let license = License
    .MIT(
        copyrightYear: 2018,
        copyrightEntity: "\(company.name) Inc."
    )
    .prepare(
        targetFolder: repoFolder
    )

//---

let tstSuffix = Defaults.tstSuffix

let targetName: PerTarget = (
    product.name,
    product.name + tstSuffix
)

let commonInfoPlistsPath = Defaults
    .pathToInfoPlistsFolder

let infoPlistsFolder = repoFolder
    .appendingPathComponent(
        commonInfoPlistsPath
    )

//---

let info: PerTarget = (
    Xcode
        .Project
        .Target
        .InfoPlist
        .iOSFramework()
        .prepare(
            name: targetName.main + ".plist",
            targetFolder: infoPlistsFolder
        ),
    Xcode
        .Project
        .Target
        .InfoPlist
        .unitTests()
        .prepare(
            name: targetName.tst + ".plist",
            targetFolder: infoPlistsFolder
        )
)

//---

let depTarget: DeploymentTarget = (.iOS, "9.0")

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

let infoPlistsPath: PerTarget = (
    commonInfoPlistsPath + "/" + info.main.name,
    commonInfoPlistsPath + "/" + info.tst.name
)

//---

let dummyFile: PerTarget = (
    Xcode
        .Project
        .Target
        .DummyFile()
        .prepare(
            targetFolder: sourcesFolder.main
        ),
    Xcode
        .Project
        .Target
        .DummyFile()
        .prepare(
            targetFolder: sourcesFolder.tst
        )
)

let project = Xcode
    .Project(product.name, specFormat: .v2_1_0){

        project in

        //---

        project.configurations.all.override(

            "IPHONEOS_DEPLOYMENT_TARGET" <<< depTarget.minimumVersion,
            "SWIFT_VERSION" <<< swiftVersion,
            "VERSIONING_SYSTEM" <<< "apple-generic"
        )

        project.configurations.debug.override(

            "SWIFT_OPTIMIZATION_LEVEL" <<< "-Onone"
        )

        //---

        project.target(targetName.main, .iOS, .framework) {

            fwk in

            //---

            fwk.include(sourcesPath.main)

            //---

            fwk.configurations.all.override(

                "IPHONEOS_DEPLOYMENT_TARGET" <<< depTarget.minimumVersion,
                "PRODUCT_BUNDLE_IDENTIFIER" <<< bundleId.main,
                "INFOPLIST_FILE" <<< infoPlistsPath.main,

                //--- iOS related:

                "SDKROOT" <<< "iphoneos",
                "TARGETED_DEVICE_FAMILY" <<< DeviceFamily.iOS.universal,

                //--- Framework related:

                "PRODUCT_NAME" <<< product.name,
                "DEFINES_MODULE" <<< "NO",
                "SKIP_INSTALL" <<< "YES" // TODO: check if we can just use Bool???
            )

            fwk.configurations.debug.override(

                "MTL_ENABLE_DEBUG_INFO" <<< true
            )

            //---

            fwk.unitTests(targetName.tst) {

                fwkTests in

                //---

                fwkTests.include(sourcesPath.tst)

                //---

                fwkTests.configurations.all.override(

                    // very important for unit tests,
                    // prevents the error when unit test do not start at all
                    "LD_RUNPATH_SEARCH_PATHS" <<<
                    "$(inherited) @executable_path/Frameworks @loader_path/Frameworks",

                    "IPHONEOS_DEPLOYMENT_TARGET" <<< depTarget.minimumVersion,

                    "PRODUCT_BUNDLE_IDENTIFIER" <<< bundleId.tst,
                    "INFOPLIST_FILE" <<< infoPlistsPath.tst,
                    "FRAMEWORK_SEARCH_PATHS" <<< "$(inherited) $(BUILT_PRODUCTS_DIR)"
                )

                fwkTests.configurations.debug.override(

                    "MTL_ENABLE_DEBUG_INFO" <<< true
                )
            }
        }
    }
    .prepare(
        targetFolder: repoFolder
    )

//---

let cocoaPodsModuleName = company.prefix + product.name

//---

let podfile = CocoaPods
    .Podfile
    .standard(
        productName: product.name,
        deploymentTarget: depTarget,
        pods: [Defaults.podsFromSpec]
    )
    .prepare(
        targetFolder: repoFolder
    )

let podspec = CocoaPods
    .Podspec
    .standard(
        product: product,
        company: company,
        license: license.model.cocoaPodsLicenseSummary,
        author: author,
        swiftVersion: swiftVersion,
        deploymentTarget: depTarget
    )
    .prepare(
        name: cocoaPodsModuleName + ".podspec",
        targetFolder: repoFolder
    )

// https://docs.fastlane.tools/getting-started/ios/setup/#use-a-gemfile
//let gemfile = Fastlane
//    .Gemfile
//    .fastlaneSupportOnly()
//    .prepare(
//        targetFolder: repoFolder
//    )

//---

let fastlaneFolder = repoFolder
    .appendingPathComponent(Defaults.pathToFastlaneFolder)

//---

let fastfile = Fastlane
    .Fastfile
    .framework(
        projectName: project.model.name,
        cocoaPodsModuleName: cocoaPodsModuleName
    )
    .prepare(
        targetFolder: fastlaneFolder
    )

// MARK: - Actually write repo configuration files

try? gitignore
    .writeToFileSystem()

try? swiftLint
    .writeToFileSystem()

try? license
    .writeToFileSystem()

try? info
    .main
    .writeToFileSystem(ifFileExists: .doNotWrite) // write OCNE!

try? info
    .tst
    .writeToFileSystem(ifFileExists: .doNotWrite) // write OCNE!

try? dummyFile
    .main
    .writeToFileSystem(ifFileExists: .doNotWrite) // write OCNE!

try? dummyFile
    .tst
    .writeToFileSystem(ifFileExists: .doNotWrite) // write OCNE!

try? project
    .writeToFileSystem()

try? podfile
    .writeToFileSystem()

try? podspec
    .writeToFileSystem()

//try? gemfile
//    .writeToFileSystem()

try? fastfile
    .writeToFileSystem()
