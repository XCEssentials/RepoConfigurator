import XCERepoConfigurator

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
    .framework()
    .prepare(
        targetFolder: repoFolder
    )

let swiftLint = SwiftLint
    .init()
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
        .Target
        .InfoPlist(
            for: .framework,
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
            preset: .iOS
        )
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

let project = Struct
    .Spec(product.name){

        project in

        //---

        project.buildSettings.base.override(

            "IPHONEOS_DEPLOYMENT_TARGET" <<< depTarget.minimumVersion,
            "SWIFT_VERSION" <<< swiftVersion,
            "VERSIONING_SYSTEM" <<< "apple-generic",

            "CURRENT_PROJECT_VERSION" <<< "0", // just a default non-empty value

            "CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING" <<< YES,
            "CLANG_WARN_COMMA" <<< YES,
            "CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS" <<< YES,
            "CLANG_WARN_NON_LITERAL_NULL_CONVERSION" <<< YES,
            "CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF" <<< YES,
            "CLANG_WARN_OBJC_LITERAL_CONVERSION" <<< YES,
            "CLANG_WARN_RANGE_LOOP_ANALYSIS" <<< YES,
            "CLANG_WARN_STRICT_PROTOTYPES" <<< YES
        )

        project.buildSettings[.debug].override(

            "SWIFT_OPTIMIZATION_LEVEL" <<< "-Onone"
        )

        //---

        project.target(targetName.main, .iOS, .framework) {

            fwk in

            //---

            fwk.include(sourcesPath.main)

            //---

            fwk.buildSettings.base.override(

                "SWIFT_VERSION" <<< "$(inherited)",

                "IPHONEOS_DEPLOYMENT_TARGET" <<< depTarget.minimumVersion,
                "PRODUCT_BUNDLE_IDENTIFIER" <<< bundleId.main,
                "INFOPLIST_FILE" <<< infoPlistsPath.main,

                //--- iOS related:

                "SDKROOT" <<< "iphoneos",
                "TARGETED_DEVICE_FAMILY" <<< DeviceFamily.iOS.universal,

                //--- Framework related:

                "CODE_SIGN_IDENTITY" <<< "",

                "PRODUCT_NAME" <<< "\(company.prefix)$(TARGET_NAME:c99extidentifier)",
                "DEFINES_MODULE" <<< NO,
                "SKIP_INSTALL" <<< YES
            )

            fwk.buildSettings[.debug].override(

                "MTL_ENABLE_DEBUG_INFO" <<< YES
            )

            //---

            fwk.unitTests(targetName.tst) {

                fwkTests in

                //---

                fwkTests.include(sourcesPath.tst)

                //---

                fwkTests.buildSettings.base.override(

                    "SWIFT_VERSION" <<< "$(inherited)",

                    // very important for unit tests,
                    // prevents the error when unit test do not start at all
                    "LD_RUNPATH_SEARCH_PATHS" <<<
                    "$(inherited) @executable_path/Frameworks @loader_path/Frameworks",

                    "IPHONEOS_DEPLOYMENT_TARGET" <<< depTarget.minimumVersion,

                    "PRODUCT_BUNDLE_IDENTIFIER" <<< bundleId.tst,
                    "INFOPLIST_FILE" <<< infoPlistsPath.tst,
                    "FRAMEWORK_SEARCH_PATHS" <<< "$(inherited) $(BUILT_PRODUCTS_DIR)"
                )

                fwkTests.buildSettings[.debug].override(

                    "MTL_ENABLE_DEBUG_INFO" <<< YES
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
    .Podfile(
        workspaceName: product.name,
        targets: [
            .target(
                targetName.main,
                deploymentTarget: depTarget,
                includePodsFromPodspec: true,
                pods: [

                    // add pods here...
                ]
            )
        ]
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
        authors: [author],
        swiftVersion: swiftVersion,
        otherSettings: [
            (
                deploymentTarget: depTarget,
                settigns: [

                    // put settings related specifically to this platform...
                    "source_files = '\(sourcesPath.main)/**/*.swift'"
                ]
            )
        ]
    )
    .prepare(
        name: cocoaPodsModuleName + ".podspec",
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

let gitHubPagesConfig = GitHub
    .PagesConfig()
    .prepare(
        targetFolder: repoFolder
    )

//---

let fastfile = Fastlane
    .Fastfile
    .framework(
        productName: product.name,
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

try? podspec
    .writeToFileSystem()

//try? gemfile
//    .writeToFileSystem()

try? fastfile
    .writeToFileSystem()

try? gitHubPagesConfig
    .writeToFileSystem()
