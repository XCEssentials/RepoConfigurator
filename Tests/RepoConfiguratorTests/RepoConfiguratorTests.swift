//
//  RepoConfiguratorTests.swift
//  RepoConfiguratorTests
//
//  Created by Maxim Khatskevich on 2018-08-04.
//  Copyright © 2018 XCEssentials. All rights reserved.
//

import XCTest

// @testable
import XCERepoConfigurator

//---

class RepoConfiguratorTests: XCTestCase
{
    lazy
    var currentBundle: Bundle = .init(for: type(of: self))

    let targetFolder = URL.init(fileURLWithPath: "") // doesn't matter

    func targetOutputFromResource(
        named resourceName: String,
        withExtension resourceExtension: String
        ) -> String
    {
        let result = try? ExternalFile
            .loadFromResource(
                named: resourceName,
                withExtension: resourceExtension
            )

        //---

        return result ?? ""
    }
}

//---

extension RepoConfiguratorTests
{
    func testSwiftLint()
    {
        let targetOutput = targetOutputFromResource(
            named: ".swiftlint",
            withExtension: "yml"
        )

        //---

        let model = SwiftLint
            .init(
                exclude: [
                    "Templates"
                ]
            )
            .prepare(
                targetFolder: targetFolder
            )

        //---

        XCTAssert(model.content == targetOutput)
    }
}
