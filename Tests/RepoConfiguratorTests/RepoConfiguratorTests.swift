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

final
class RepoConfiguratorTests: XCTestCase
{
    static
    var allTests = [
        ("testSwiftLint", testSwiftLint)
        ]

    //---

    lazy
    var currentBundle: Bundle = .init(for: type(of: self))

    let targetFolder = URL.init(fileURLWithPath: "") // doesn't matter
}

//---

extension RepoConfiguratorTests
{
    func testSwiftLint()
    {
        let targetOutput = """
            # see docs at https://github.com/realm/SwiftLint

            disabled_rules:
              - function_parameter_count
              - trailing_newline
              - closure_parameter_position
              - opening_brace
              - nesting
              - function_body_length
              - file_length

            included: # paths to include during linting. `--path` is ignored if present.
              - Sources
              - Tests

            excluded: # paths to ignore during linting. Takes precedence over `included`.
              - Resources
              - Carthage
              - Pods
              - Templates

            # rules options:

            line_length:
              ignores_comments: true
            trailing_whitespace:
              ignores_empty_lines: true
            type_name:
              allowed_symbols: _
            statement_position:
              # https://github.com/realm/SwiftLint/issues/1181#issuecomment-272445593
              statement_mode: uncuddled_else
            """

        //---

        let model = SwiftLint
            .init(
                .disabledRules(),
                .included(),
                .excluded([
                    "Templates"
                ]),
                .rulesOptions()
            )
            .prepare(
                targetFolder: targetFolder
            )

        //---

        XCTAssert(model.content == targetOutput)
    }
}
