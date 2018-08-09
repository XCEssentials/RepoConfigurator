[![GitHub license](https://img.shields.io/github/license/XCEssentials/ValidatableValue.svg)](https://github.com/XCEssentials/ValidatableValue/blob/master/LICENSE)
[![GitHub tag](https://img.shields.io/github/tag/XCEssentials/ValidatableValue.svg)](https://github.com/XCEssentials/ValidatableValue)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-brightgreen.svg)](https://github.com/Carthage/Carthage)
[![Requires Xcode](https://img.shields.io/badge/requires-Xcode-lightgray.svg)](https://developer.apple.com/xcode/)
[![Written in Swift](https://img.shields.io/badge/Swift-4-orange.svg)](https://developer.apple.com/swift/)

# RepoConfigurator

Generate repo config files using Swift and Xcode playgrounds.



## Installation

Install as dependency via [Carthage](https://github.com/Carthage/Carthage).

```rub
github "XCEssentials/RepoConfigurator"
```



## Usage

The goal is to create an Xcode playground file that will hold all the settings for the repo and will be used as a script (written in Swift, with Xcode syntax highlight, compilation time type-checking and code completion) which you can run any time on demand to generate and re-generate all sorts of infrastructure / settings / configuration files for the repo ([gitignore](https://git-scm.com/docs/gitignore), [Fastfile](https://fastlane.tools/), [Podfile](https://guides.cocoapods.org/syntax/podfile.html), etc.), to easily keep them all up to date and in coherence with each other.



### Step 1 — prepare the config

Create an Xcode workspace. Then create a blank Xcode playground — it is going to be our config script — and add it to the workspace (you can also use one of the templates from `Templates` folder inside the repo). After that, any framework project added to this workspace (and built for 'My Mac' device) will be available for import inside the playground. We will use it to our advantage to make the `RepoConfigurator` framework available inside our config playground.



### Step 2 — fetch dependencies

Open a command line, navigate to the root repo folder & fetch dependencies by running the following.

```bash
carthage update --no-build
```

Note, that we added the `--no-build` option, because we don't need the `RepoConfigurator` to be built for you, as we won't use it in binary form. Omit this option if you need other `Carthage` dependencies to be built.



### Step 3 — connect framework with config

After fetching dependencies with `Carthage`, navigate to `Carthage/Checkouts` folder inside your root repo folder, then go to `RepoConfigurator` folder and find its project file (`RepoConfigurator.xcodeproj`). Grab that project file and drag&drop it to the workspace.



### Step 4 — write the actual config

Take your time to write the actual config and tailor it to your needs. Take a look on the example configs from `Examples` folder inside this repo.



### Step 5 — execute the playground

When your config is ready — execute the playground to actually generate the files you described in there.



## Conclusion

Note, that you might want to write some files only once during the repo lifetime (in the beginning), but in most cases it is supposed that all those files described in the config should be kept up to date only via this config. So whenever you want to rename the product or change any of it's settings, or add a CocoaPods dependency — those fixes should be done in the config and then entire playgroudn should be executed to regenerate everything. This way we always can guarantee that everything is up to date and in sync with each other, plus it's super easy to review all settings in one place.