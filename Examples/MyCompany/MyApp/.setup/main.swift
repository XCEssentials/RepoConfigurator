import FileKit

import XCERepoConfigurator

// MARK: - PRE-script invocation output

print("\n")
print("--- BEGIN of '\(Executable.name!)' script ---")

// MARK: -

// MARK: Parameters

 Spec.BuildSettings.swiftVersion.value = "4.2"

let localRepo = try Spec.LocalRepo.current()

let remoteRepo = try Spec.RemoteRepo()

let company = try Spec.Company(
    identifier: "com.\(remoteRepo.accountName)"
)

let project = try Spec.Project(
    summary: "The greates app idea ever",
    copyrightYear: 2019,
    deploymentTargets: [
        .iOS : "9.0"
    ]
)

let license = (
    text: "Do NOT use any of the code without author's written permission.",
    name: "Proprietary",
    location: Path(Defaults.licenseFileName)
)

var masterCocoaPod = try Spec.CocoaPod(
    companyInfo: .from(company),
    productInfo: .from(project),
    authors: [
        ("Maxim Khatskevich", "maxim@khatskevi.ch")
    ]
)

try? masterCocoaPod.readCurrentVersion(
    callFastlane: .viaBundler
)

let modules = try (
    mobileViews: Spec.ArchitecturalLayer(
        project: project,
        name: "MobileViews",
        summary: "[View] level types according to MVVMSE.",
        deploymentTargets: project
            .deploymentTargets
            .filter{ $0.key == .iOS }
    ),
    viewModels: Spec.ArchitecturalLayer(
        project: project,
        name: "ViewModels",
        summary: "[ViewModel] level types according to MVVMSE."
    ),
    models: Spec.ArchitecturalLayer(
        project: project,
        name: "Models",
        summary: "[Model] level types according to MVVMSE."
    ),
    services: Spec.ArchitecturalLayer(
        project: project,
        name: "Services",
        summary: "[Service] level types according to MVVMSE."
    )
)

let targets = (
    app: try Spec.Target(
        "App",
        project: project,
        platform: modules.viewModels.deploymentTargets.asPairs()[0].platform,
        bundleIdInfo: .autoWithCompany(company),
        provisioningProfiles: [.dev, .adHoc].reduce(into: [:]){
            
            $0[$1] = project.name + "-" + $1.title
        },
        packageType: .app
    ),
    none: () // to keep the 'targets' as tuple even if we have on 1 target
)

let targetedDeviceFamilyFor = ( // per target
    app: DeviceFamily.iOS.phone, // NO iPad support yet!
    none: () // to keep the 'targets' as tuple even if we have on 1 target
)

let sharedPodDependencies: [String] = [
    "XCEPipeline",
    "XCEArrayExt"
]

let allSubspecs = [
    modules.mobileViews.main,
    modules.mobileViews.tests,
    modules.viewModels.main,
    modules.viewModels.tests,
    modules.models.main,
    modules.models.tests,
    modules.services.main,
    modules.services.tests
]

// MARK: Parameters - Summary

localRepo.report()
remoteRepo.report()
company.report()
project.report()

// MARK: -

// MARK: Write - Dummy files

try (
    allSubspecs.map{ $0.sourcesLocation } +
        [targets.app.sourcesLocation]
    )
    .map{
        
        localRepo.location + $0
    }
    .map{
        
        try DummyFile().prepare(absolutePrefixLocation: $0)
    }
    .forEach{
        
        try $0.writeToFileSystem(ifFileExists: .skip)
    }

// MARK: Write - Bundler - Gemfile

// https://docs.fastlane.tools/getting-started/ios/setup/#use-a-gemfile
try Bundler
    .Gemfile(
        basicFastlane: true,
        """
        gem 'cocoapods', '~> 1.6.0.beta.2'
        """
    )
    .prepare()
    .writeToFileSystem()

// MARK: Write - ReadMe

try ReadMe()
    .addGitHubTagBadge(
        account: remoteRepo.accountName,
        repo: remoteRepo.name
    )
    .addWrittenInSwiftBadge(
        version: Spec.BuildSettings.swiftVersion.value
    )
    .add("""

        # MyApp

        Project description goes here...

        """
    )
    .prepare(
        removeRepeatingEmptyLines: false
    )
    .writeToFileSystem()

// MARK: Write - SwiftLint

try SwiftLint
    .standard()
    .prepare()
    .writeToFileSystem()

// MARK: Write - Info Plists

try [
    targets.app
    ]
    .map{
        
        try Xcode.InfoPlist.prepare(
            for: project,
            target: $0
        )
    }
    .forEach{
        
        try $0.writeToFileSystem(ifFileExists: .skip)
    }

// MARK: Write - License

try CustomTextFile
    .init(
        license.text
    )
    .prepare(
        absoluteLocation: localRepo.location + license.location
    )
    .writeToFileSystem()

// MARK: Write - CocoaPods - Podspec MASTER

try CocoaPods
    .Podspec
    .standard(
        product: masterCocoaPod.product,
        company: masterCocoaPod.company,
        version: masterCocoaPod.currentVersion,
        license: (license.name, license.location),
        authors: masterCocoaPod.authors,
        swiftVersion: Spec.BuildSettings.swiftVersion.value,
        globalSettings: {
            
            globalContext in
            
            //declare support for all defined deployment targets
            
            project
                .deploymentTargets
                .forEach{ globalContext.settings(for: $0) }
        }
    )
    .prepare(for: masterCocoaPod)
    .writeToFileSystem()

// MARK: Write - CocoaPods - Podspecs for modules

try [modules.mobileViews].forEach{ module in

    try CocoaPods
        .Podspec
        .standard(
            product: module.product,
            company: masterCocoaPod.company,
            version: masterCocoaPod.currentVersion,
            license: (license.name, license.location),
            authors: masterCocoaPod.authors,
            swiftVersion: Spec.BuildSettings.swiftVersion.value,
            globalSettings: {
                
                podspec in
                
                //---
                
                module
                    .deploymentTargets
                    .asPairs()
                    .forEach{ podspec.settings(for: $0) }
                
                podspec.settings(
                    sharedPodDependencies.map{ .dependency($0) }
                )
                
                podspec.settings(
                    .noPrefix("framework = 'UIKit'"),
                    .dependency(modules.viewModels.product.name), // <<<======= lower layer
                    .sourceFiles(module.main.sourcesPattern)
                )
            },
            testSubSpecs: {
                
                $0.testSubSpec(module.tests.name){
                    
                    $0.settings(
                        .noPrefix("requires_app_host = false"),
                        .sourceFiles(module.tests.sourcesPattern)
                    )
                }
            }
        )
        .prepare(relativeLocation: module.podspecLocation)
        .writeToFileSystem()
}

try [modules.viewModels].forEach{ module in

    try CocoaPods
        .Podspec
        .standard(
            product: module.product,
            company: masterCocoaPod.company,
            version: masterCocoaPod.currentVersion,
            license: (license.name, license.location),
            authors: masterCocoaPod.authors,
            swiftVersion: Spec.BuildSettings.swiftVersion.value,
            globalSettings: {
                
                podspec in
                
                //---
                
                module
                    .deploymentTargets
                    .asPairs()
                    .forEach{ podspec.settings(for: $0) }
                
                podspec.settings(
                    sharedPodDependencies.map{ .dependency($0) }
                )
                
                podspec.settings(
                    .dependency(modules.models.product.name), // <<<======= lower layer
                    .sourceFiles(module.main.sourcesPattern)
                )
            },
            testSubSpecs: {
                
                $0.testSubSpec(module.tests.name){
                    
                    $0.settings(
                        .noPrefix("requires_app_host = false"),
                        .sourceFiles(module.tests.sourcesPattern)
                    )
                }
            }
        )
        .prepare(relativeLocation: module.podspecLocation)
        .writeToFileSystem()
}

try [modules.models].forEach{ module in

    try CocoaPods
        .Podspec
        .standard(
            product: module.product,
            company: masterCocoaPod.company,
            version: masterCocoaPod.currentVersion,
            license: (license.name, license.location),
            authors: masterCocoaPod.authors,
            swiftVersion: Spec.BuildSettings.swiftVersion.value,
            globalSettings: {
                
                podspec in
                
                //---
                
                module
                    .deploymentTargets
                    .asPairs()
                    .forEach{ podspec.settings(for: $0) }
                
                podspec.settings(
                    sharedPodDependencies.map{ .dependency($0) }
                )
                
                podspec.settings(
                    .dependency(modules.services.product.name), // <<<======= lower layer
                    .sourceFiles(module.main.sourcesPattern)
                )
            },
            testSubSpecs: {
                
                $0.testSubSpec(module.tests.name){
                    
                    $0.settings(
                        .noPrefix("requires_app_host = false"),
                        .sourceFiles(module.tests.sourcesPattern)
                    )
                }
            }
        )
        .prepare(relativeLocation: module.podspecLocation)
        .writeToFileSystem()
}

try [modules.services].forEach{ module in

    try CocoaPods
        .Podspec
        .standard(
            product: module.product,
            company: masterCocoaPod.company,
            version: masterCocoaPod.currentVersion,
            license: (license.name, license.location),
            authors: masterCocoaPod.authors,
            swiftVersion: Spec.BuildSettings.swiftVersion.value,
            globalSettings: {
                
                podspec in
                
                //---
                
                module
                    .deploymentTargets
                    .asPairs()
                    .forEach{ podspec.settings(for: $0) }
                
                // === >>> NO lower layer dependency, as it's the lowest level
                
                podspec.settings(
                    sharedPodDependencies.map{ .dependency($0) }
                )
                
                podspec.settings(
                    .sourceFiles(module.main.sourcesPattern)
                )
            },
            testSubSpecs: {
                
                $0.testSubSpec(module.tests.name){
                    
                    $0.settings(
                        .noPrefix("requires_app_host = false"),
                        .sourceFiles(module.tests.sourcesPattern)
                    )
                }
            }
        )
        .prepare(relativeLocation: module.podspecLocation)
        .writeToFileSystem()
}

// MARK: Write - CocoaPods - Podfile

try CocoaPods
    .Podfile(
        workspaceName: project.name
    )
    .custom("""
        install! 'cocoapods',
            :deterministic_uuids => false
        """
    )
    // .postInstall(...)
    .target(
        targets.app.name,
        projectName: project.name,
        deploymentTarget: targets.app.deploymentTarget,
        pods: [
            
            "pod '\(modules.mobileViews.product.name)', :path => './', :testspecs => ['Tests']",
            "pod '\(modules.viewModels.product.name)', :path => './', :testspecs => ['Tests']",
            "pod '\(modules.models.product.name)', :path => './', :testspecs => ['Tests']",
            "pod '\(modules.services.product.name)', :path => './', :testspecs => ['Tests']",

            "# --- here override sources for any needed pods...",
            
            "# --- list any app-level pods like crash reporting, Reveal, etc.",
            
            "pod 'Reveal-SDK', '13', :configurations => ['Debug']",
            "pod 'HockeySDK', '~> 4.1.0', :subspecs => ['CrashOnlyLib']"
        ]
    )
    .prepare()
    .writeToFileSystem()

// MARK: Write - Fastlane - Fastfile

try Fastlane
    .Fastfile
    .ForApp()
    .defaultHeader()
    .beforeRelease(
        project: project,
        masterPod: masterCocoaPod,
        otherPodSpecs: [
            modules.mobileViews,
            modules.viewModels,
            modules.models,
            modules.services
            ]
            .map{ $0.podspecLocation }
    )
    .reconfigureProject(
        project: project,
        scriptBuildPhases: {

            try $0.swiftLint(
                project: project.location,
                targetNames: [targets.app.name],
                params: [
                    
                    """
                    --path "${SRCROOT}/\(targets.app.sourcesLocation.rawValue)"
                    """
                ]
            )
        },
        buildSettings: {

            $0.projectLevel(
                project: project,
                shared: [
                    "SWIFT_VERSION" : Spec.BuildSettings.swiftVersion,
                    "ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES" : YES,
                    "IPHONEOS_DEPLOYMENT_TARGET" : targets.app.deploymentTarget.minimumVersion,
                    "TARGETED_DEVICE_FAMILY" : targetedDeviceFamilyFor.app,
                    "LD_RUNPATH_SEARCH_PATHS" : "$(FRAMEWORK_SEARCH_PATHS) $(BUILT_PRODUCTS_DIR)"
                ]
            )

            $0.targetLevel(
                project: project,
                target: targets.app.name,
                shared: [
                    "PRODUCT_NAME" : targets.app.productName,
                    "CODE_SIGN_STYLE" : "Manual",
                    "INFOPLIST_FILE" : targets.app.infoPlistLocation.rawValue
                ],
                perConfiguration: [
                    .debug : [
                        "CODE_SIGN_IDENTITY" : "iPhone Developer",
                        "PROVISIONING_PROFILE_SPECIFIER" : targets.app.provisioningProfiles[.dev].require()
                    ],
                    .release : [
                        "CODE_SIGN_IDENTITY" : "iPhone Distribution",
                        "PROVISIONING_PROFILE_SPECIFIER" : targets.app.provisioningProfiles[.adHoc].require()
                    ]
                ]
            )
        },
        endingEntries: (
            allSubspecs.map{ $0.linterCfgLocation } +
            [targets.app.linterCfgLocation]
            )
            .map{
                
                Utils.symLinkCmd(
                    ("$PWD" + SwiftLint.relativeLocation).rawValue,
                    $0.rawValue
                )
            }
            .map{
                
                """
                sh 'cd ./.. && \($0)'
                """
            }
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
            """
        ]
    )
    .prepare()
    .writeToFileSystem()

// MARK: - POST-script invocation output

print("--- END of '\(Executable.name!)' script ---")
