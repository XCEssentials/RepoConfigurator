/*
 
 MIT License
 
 Copyright (c) 2018 Maxim Khatskevich
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 
 */

import XCTest

import SwiftHamcrest

// @testable
import XCERepoConfigurator

//---

final
class SwiftLintTests: FileModelTestsContext
{
    // MARK: Type level members
    
    static
    var allTests = [
        ("testBasicConfig", testBasicConfig)
    ]
    
}

//---

extension SwiftLintTests
{
    func testBasicConfig()
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

            excluded: # paths to ignore during linting. Takes precedence over `included`.
              - Resources
              - Carthage
              - Pods
              - Templates
            """

        //---

        let model = try! SwiftLint
            .standard(
                exclude: [
                    "Templates"
                ]
            )
            .prepare(
                absolutePrefixLocation: someLocation
            )

        //---

        assertThat(model.content == targetOutput)
    }
}
