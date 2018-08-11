//import XCERepoConfigurator
//
////---
//
//// one item for main target, and one - for unit tests
//typealias PerTarget<T> = (main: T, tst: T)
//
////---
//
//let productName = "<#SomeProduct#>"
//
//let company = (
//    name: "<#SomeCoolCompany#>",
//    identifier: "<#com.SomeCoolCompany#>",
//    prefix: "<#SCC#>",
//    developmentTeamId: "<#ABCXYZ123#>"
//)
//
//let repoFolder = PathPrefix
//    //.iCloudDrive
//    //.userHomeDir
//    .appendingPathComponent(
//        "<#Dev#>"
//    )
//    .appendingPathComponent(
//        "<#Work#>"
//    )
//    .appendingPathComponent(
//        productName
//    )
//
//let tstSuffix = Defaults.tstSuffix
//
//let targetName: PerTarget = (
//    productName,
//    productName + tstSuffix
//)
//
//let commonInfoPlistsPath = Defaults
//    .pathToInfoPlistsFolder
//
//let infoPlistsFolder = repoFolder
//    .appendingPathComponent(
//        commonInfoPlistsPath
//    )
//
//let depTarget: DeploymentTarget = (<#OSIdentifier#>, "<#11.0#>")
//
//let swiftVersion: VersionString = "<#4.2#>"
//
//let commonSourcesPath = Defaults.pathToSourcesFolder
//
//let sourcesPath: PerTarget = (
//    commonSourcesPath + "/" + targetName.main,
//    commonSourcesPath + "/" + targetName.tst
//)
//
//let sourcesFolder: PerTarget = (
//    repoFolder
//        .appendingPathComponent(
//            sourcesPath.main
//    ),
//    repoFolder
//        .appendingPathComponent(
//            sourcesPath.tst
//    )
//)
//
//let bundleId: PerTarget = (
//    company.identifier + "." + targetName.main,
//    company.identifier + "." + targetName.tst
//)
//
////---
//
//let gitignore = Git
//    .RepoIgnore
//    .app()
//    .prepare(
//        targetFolder: repoFolder
//    )
//
//let swiftLint = SwiftLint
//    .defaultXCE()
//    .prepare(
//        targetFolder: repoFolder
//    )
//
//let info: PerTarget = (
//    Xcode
//        .Project
//        .Target
//        .InfoPlist
//        .iOSApp()
//        .prepare(
//            name: targetName.main + ".plist",
//            targetFolder: infoPlistsFolder
//        ),
//    Xcode
//        .Project
//        .Target
//        .InfoPlist
//        .unitTests()
//        .prepare(
//            name: targetName.tst + ".plist",
//            targetFolder: infoPlistsFolder
//        )
//)
//
//let emptyFile: PerTarget = (
//    Xcode
//        .Project
//        .Target
//        .EmptyFile()
//        .prepare(
//            name: targetName.main + ".swift",
//            targetFolder: sourcesFolder.main
//        ),
//    Xcode
//        .Project
//        .Target
//        .EemptyFile()
//        .prepare(
//            name: targetName.tst + ".swift",
//            targetFolder: sourcesFolder.tst
//        )
//)
//
////---
//
//let infoPlistsPath: PerTarget = (
//    commonInfoPlistsPath + "/" + info.main.name,
//    commonInfoPlistsPath + "/" + info.tst.name
//)
//
//let testHostPath = "$(BUILT_PRODUCTS_DIR)/"
//    + productName
//    + ".app/"
//    + productName
//
////---
//
//let project = Xcode
//    .Project(productName, specFormat: .v2_1_0){
//
//        project in
//
//        //---
//
//        project.configurations.all.override(
//
//            "DEVELOPMENT_TEAM" <<< company.developmentTeamId,
//
//            "IPHONEOS_DEPLOYMENT_TARGET" <<< depTarget.minimumVersion,
//            "SWIFT_VERSION" <<< swiftVersion,
//            "VERSIONING_SYSTEM" <<< "apple-generic",
//            
//            "CURRENT_PROJECT_VERSION" <<< "0", // just a default non-empty value
//
//            "CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING" <<< YES,
//            "CLANG_WARN_COMMA" <<< YES,
//            "CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS" <<< YES,
//            "CLANG_WARN_NON_LITERAL_NULL_CONVERSION" <<< YES,
//            "CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF" <<< YES,
//            "CLANG_WARN_OBJC_LITERAL_CONVERSION" <<< YES,
//            "CLANG_WARN_RANGE_LOOP_ANALYSIS" <<< YES,
//            "CLANG_WARN_STRICT_PROTOTYPES" <<< YES
//
//        )
//
//        project.configurations.debug.override(
//
//            "SWIFT_OPTIMIZATION_LEVEL" <<< "-Onone"
//        )
//
//        //---
//
//        project.target(targetName.main, .iOS, .app) {
//
//            app in
//
//            //---
//
//            app.include(sourcesPath.main)
//
//            //---
//
//            app.configurations.all.override(
//
//                "SWIFT_VERSION" <<< "$(inherited)",
//
//                "IPHONEOS_DEPLOYMENT_TARGET" <<< depTarget.minimumVersion,
//                "PRODUCT_BUNDLE_IDENTIFIER" <<< bundleId.main,
//                "INFOPLIST_FILE" <<< infoPlistsPath.main,
//
//                //--- iOS related:
//
//                "SDKROOT" <<< "iphoneos",
//                "TARGETED_DEVICE_FAMILY" <<< DeviceFamily.iOS.phone
//            )
//
//            app.configurations.debug.override(
//
//                "MTL_ENABLE_DEBUG_INFO" <<< YES
//            )
//
//            //---
//
//            app.unitTests(targetName.tst) {
//
//                appTests in
//
//                //---
//
//                appTests.include(sourcesPath.tst)
//
//                //---
//
//                appTests.configurations.all.override(
//
//                    "TEST_HOST" <<< testHostPath,
//                    
//                    "SWIFT_VERSION" <<< "$(inherited)",
//
//                    // very important for unit tests,
//                    // prevents the error when unit test do not start at all
//                    "LD_RUNPATH_SEARCH_PATHS" <<<
//                    "$(inherited) @executable_path/Frameworks @loader_path/Frameworks",
//
//                    "IPHONEOS_DEPLOYMENT_TARGET" <<< depTarget.minimumVersion,
//
//                    "PRODUCT_BUNDLE_IDENTIFIER" <<< bundleId.tst,
//                    "INFOPLIST_FILE" <<< infoPlistsPath.tst,
//                    "FRAMEWORK_SEARCH_PATHS" <<< "$(inherited) $(BUILT_PRODUCTS_DIR)"
//                )
//
//                appTests.configurations.debug.override(
//
//                    "MTL_ENABLE_DEBUG_INFO" <<< YES
//                )
//            }
//        }
//    }
//    .prepare(
//        targetFolder: repoFolder
//    )
//
//let podfile = CocoaPods
//    .Podfile
//    .standard(
//        productName: productName,
//        deploymentTarget: depTarget,
//        pods: [
//
//            <#// add pods here!#>
//        ]
//    )
//    .prepare(
//        targetFolder: repoFolder
//    )
//
//// https://docs.fastlane.tools/getting-started/ios/setup/#use-a-gemfile
////let gemfile = Fastlane
////    .Gemfile
////    .fastlaneSupportOnly()
////    .prepare(
////        targetFolder: repoFolder
////    )
//
////---
//
//let fastlaneFolder = repoFolder
//    .appendingPathComponent(
//        Defaults.pathToFastlaneFolder
//    )
//
//let schemeStaging = targetName.main
//
////---
//
//let fastfile = Fastlane
//    .Fastfile
//    .app(
//        productName: productName,
//        usesSwiftGen: <#false#>,
//        usesSourcery: <#false#>,
//        usesSwiftLint: <#.global#>,
//        stagingSchemeName: schemeStaging,
//        stagingExportMethod: <#.adHoc#>
//    )
//    .prepare(
//        targetFolder: fastlaneFolder
//    )
//
//// MARK: - Actually write repo configuration files
//
//try? gitignore
//    .writeToFileSystem()
//
//try? swiftLint
//    .writeToFileSystem()
//
//try? info
//    .main
//    .writeToFileSystem(ifFileExists: .doNotWrite) // write ONCE!
//
//try? info
//    .tst
//    .writeToFileSystem(ifFileExists: .doNotWrite) // write ONCE!
//
//try? emptyFile
//    .main
//    .writeToFileSystem(ifFileExists: .doNotWrite) // write ONCE!
//
//try? emptyFile
//    .tst
//    .writeToFileSystem(ifFileExists: .doNotWrite) // write ONCE!
//
//try? project
//    .writeToFileSystem()
//
//try? podfile
//    .writeToFileSystem()
//
////try? gemfile
////    .writeToFileSystem()
//
//try? fastfile
//    .writeToFileSystem()
