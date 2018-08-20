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

/**
 https://github.com/realm/SwiftLint
 */
public
struct SwiftLint: FixedNameTextFile
{
    // MARK: - Type level members

    public
    static
    let fileName = ".swiftlint.yml"

    public
    typealias RuleOption = (

        rule: String,
        option: String,
        value: String
    )

    // MARK: - Instance level members

    public
    let fileContent: IndentedText

    // MARK: - Initializers

    public
    init(
        defaultXCESettings: Bool = true,
        disabledRules: [String] = [],
        exclude: [String] = [],
        rulesOptions: [RuleOption] = [],
        otherEntries: [String] = []
        )
    {
        let result = IndentedTextBuffer()

        //---

        let sections: [TextFileSection<SwiftLint>] = [

            .disabledRules(
                setXCEDefaults: defaultXCESettings,
                disabledRules
            ),
            .exclude(
                setXCEDefaults: defaultXCESettings,
                exclude
            ),
            .rulesOptions(
                setXCEDefaults: defaultXCESettings,
                rulesOptions
            )
        ]

        //---

        result <<< """
            # see docs at https://github.com/realm/SwiftLint

            """

        result <<< sections

        result <<< otherEntries.map{ """

            \($0)
            """
        }

        //---

        fileContent = result.content
    }
}

// MARK: - Content rendering

fileprivate
extension TextFileSection
    where
    Context == SwiftLint
{
    static
    func disabledRules(
        setXCEDefaults: Bool,
        _ otherDisabledRules: [String]
        ) -> TextFileSection<Context>
    {
        return .init{

            indentation in

            //---

            let result: IndentedTextBuffer = .init(with: indentation)

            //---

            result <<< """

                disabled_rules:
                """

            indentation.nest{

                result <<< setXCEDefaults.mapIf(true){ """
                    - function_parameter_count
                    - trailing_newline
                    - closure_parameter_position
                    - opening_brace
                    - nesting
                    - function_body_length
                    - file_length
                    """
                }

                result <<< otherDisabledRules.map{ """
                    - \($0)
                    """
                }
            }

            //---

            return result.content
        }
    }

    static
    func exclude(
        setXCEDefaults: Bool,
        _ otherExclude: [String]
        ) -> TextFileSection<Context>
    {
        return .init{

            indentation in

            //---

            let result: IndentedTextBuffer = .init(with: indentation)

            //---

            result <<< """

                # paths to ignore during linting. Takes precedence over 'included'.
                excluded:
                """

            indentation.nest{

                result <<< setXCEDefaults.mapIf(true){ """
                    - Resources
                    - Carthage
                    - Pods
                    """
                }

                result <<< otherExclude.map{ """
                    - \($0)
                    """
                }
            }

            //---

            return result.content
        }
    }

    static
    func rulesOptions(
        setXCEDefaults: Bool,
        _ otherRulesOptions: [SwiftLint.RuleOption]
        ) -> TextFileSection<Context>
    {
        return .init{

            indentation in

            //---

            let result: IndentedTextBuffer = .init(with: indentation)

            //---

            result <<< (setXCEDefaults || !otherRulesOptions.isEmpty).mapIf(true){"""

                # rules options:
                """
            }

            result <<< setXCEDefaults.mapIf(true){

                // NOTE: NO extra indentation!

                """
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
            }

            result <<< otherRulesOptions.map{

                // NOTE: NO extra indentation!

                """
                \($0.rule):
                    \($0.option): \($0.value)
                """
            }

            //---

            return result.content
        }
    }
}
