[![GitHub License](https://img.shields.io/github/license/XCEssentials/RepoConfigurator.svg?longCache=true)](LICENSE)
[![GitHub Tag](https://img.shields.io/github/tag/XCEssentials/RepoConfigurator.svg?longCache=true)](https://github.com/XCEssentials/RepoConfigurator/tags)
[![Swift Package Manager Compatible](https://img.shields.io/badge/SPM-compatible-brightgreen.svg?longCache=true)](Package.swift)
[![Written in Swift](https://img.shields.io/badge/Swift-5.0-orange.svg?longCache=true)](https://swift.org)
[![Supported platforms](https://img.shields.io/badge/platforms-macOS-blue.svg?longCache=true)](Package.swift)
[![Build Status](https://travis-ci.com/XCEssentials/RepoConfigurator.svg?branch=master)](https://travis-ci.com/XCEssentials/RepoConfigurator)

# RepoConfigurator

Generate repo config files using Swift and Xcode.

## Usage

The goal is to create a Swift script file that will contain all the settings for the repo (Swift version number, product name, company name, author(s) name, company prefix, project and target(s) names(s), etc.) and which you can run on demand to generate and re-generate all sorts of infrastructure / settings / configuration files for the repo ([gitignore](https://git-scm.com/docs/gitignore), [Fastfile](https://fastlane.tools/), [Podfile](https://guides.cocoapods.org/syntax/podfile.html), etc.), to easily keep them all up to date and in coherence with each other.

Note, that you might want to write some files only once during the repo lifetime (in the beginning), but in most cases it is supposed that all those files described in the config should be kept up to date only via this config. So whenever you want to rename the product or change any of it's settings, or add a CocoaPods dependency — those fixes should be done in the config script and then entire script should be executed to regenerate everything. This way we always can guarantee that everything is up to date and in sync with each other, plus it's super easy to review all settings in one place.

## Installation

`XCERepoConfigurator` is a standard SwiftPM-compatible [package](Package.swift), so it can be used as dependincy in any [SPM](https://github.com/apple/swift-package-manager/tree/master/Documentation) based script.

## Usage

To get an idea of how to use this library, see `.setup/main.swift` in this repo and also templates for [Cocoa app](https://github.com/XCEssentials/AppTemplate) and [Cocoa framework](https://github.com/XCEssentials/FrameworkTemplate).

## Remember

Most of the initializers have some parameters with default values, look into sources to discover all available parameters to configure output file according to your needs.

## Development

This repo uses itself for generating various infrastructure files in the repo, so go to `.setup` folder and run the SPM script located there by executing `swift run`.
