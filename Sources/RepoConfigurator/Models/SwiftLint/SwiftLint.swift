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

import FileKit

//---

/**
 https://github.com/realm/SwiftLint
 */
public
final
class SwiftLint: FixedNameTextFile
{
    // MARK: Type level members

    public
    static
    let relativeLocation: Path = [".swiftlint.yml"]

    public
    typealias RuleOption = (

        rule: String,
        option: String,
        value: String
    )

    // MARK: Instance level members

    private
    var buffer: IndentedTextBuffer = .init(
        with: Defaults.YAMLIndentation
    )

    public
    var fileContent: IndentedText
    {
        return buffer.content
    }

    // MARK: Initializers

    public
    init()
    {
        buffer <<< """
            # see docs at https://github.com/realm/SwiftLint

            """
    }
}

// MARK: - Presets

public
extension SwiftLint
{
    static
    func standard(
        setXCEDefaults: Bool = true,
        disabledRules: [String] = [],
        include: [String] = [],
        exclude: [String] = [],
        rulesOptions: [SwiftLint.RuleOption] = [],
        otherEntries: [String] = []
        ) -> SwiftLint
    {
        let result = SwiftLint()
            .addDisabledRules(
                setXCEDefaults: setXCEDefaults,
                disabledRules
            )
            .addIncluded(
                include
            )
            .addRulesOptions(
                setXCEDefaults: setXCEDefaults,
                rulesOptions
            )

        //---

        if
            !exclude.isEmpty
        {
            _ = result.addExcluded(
                setXCEDefaults: setXCEDefaults,
                exclude
            )
        }

        otherEntries.forEach{

            _ = result.add($0)
        }

        //---

        return result
    }
}

// MARK: - Content rendering

public
extension SwiftLint
{
    func addDisabledRules(
        setXCEDefaults: Bool = true,
        _ otherDisabledRules: [String] = []
        ) -> SwiftLint
    {
        buffer <<< """

            disabled_rules:
            """

        buffer.indentation.nest{

            buffer <<< setXCEDefaults.mapIf(true){ """
                - function_parameter_count
                - trailing_newline
                - closure_parameter_position
                - opening_brace
                - nesting
                - function_body_length
                - file_length
                """
            }

            buffer <<< otherDisabledRules.map{ """
                - \($0)
                """
            }
        }

        //---

        return self
    }

    func addIncluded(
        _ paths: [String] = []
        ) -> SwiftLint
    {
        guard
            !paths.isEmpty
        else
        {
            return self
        }
        
        //---
        
        buffer <<< """

            included: # paths to include during linting. `--path` is ignored if present.
            """

        buffer.indentation.nest{

            buffer <<< paths.map{ """
                - \($0)
                """
            }
        }

        //---

        return self
    }

    func addExcluded(
        setXCEDefaults: Bool = true,
        _ otherExclude: [String] = []
        ) -> SwiftLint
    {
        buffer <<< """

            excluded: # paths to ignore during linting. Takes precedence over `included`.
            """

        buffer.indentation.nest{

            buffer <<< setXCEDefaults.mapIf(true){ """
                - Resources
                - Carthage
                - Pods
                """
            }

            buffer <<< otherExclude.map{ """
                - \($0)
                """
            }
        }

        //---

        return self
    }

    func addRulesOptions(
        setXCEDefaults: Bool = true,
        _ otherRulesOptions: [SwiftLint.RuleOption] = []
        ) -> SwiftLint
    {
        buffer <<< (setXCEDefaults || !otherRulesOptions.isEmpty).mapIf(true){"""

            # rules options:

            """
        }

        let i = buffer.indentation.singleLevel //swiftlint:disable:this identifier_name

        buffer <<< setXCEDefaults.mapIf(true){

            // NOTE: NO extra indentation!

            """
            line_length:
            \(i)ignores_comments: true
            trailing_whitespace:
            \(i)ignores_empty_lines: true
            type_name:
            \(i)allowed_symbols: _
            statement_position:
            \(i)# https://github.com/realm/SwiftLint/issues/1181#issuecomment-272445593
            \(i)statement_mode: uncuddled_else
            """
        }

        buffer <<< otherRulesOptions.map{

            // NOTE: NO extra indentation!

            """
            \($0.rule):
                \($0.option): \($0.value)
            """
        }

        //---

        return self
    }

    func add(
        _ customEntry: String
        ) -> SwiftLint
    {
        buffer <<< """

            \(customEntry)
            """

        //---

        return self
    }
}
