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
    // MARK: Type level members

    public
    static
    let fileName = ".swiftlint.yml"

    public
    typealias RuleOption = (

        rule: String,
        option: String,
        value: String
    )

    // MARK: Instance level members

    public
    let fileContent: IndentedText

    // MARK: Initializers

    public
    init(
        sections: [TextFileSection<SwiftLint>]
        )
    {
        let result: IndentedTextBuffer = .init(
            with: Defaults.singleLevelOfIndentationForYAMLFiles
        )

        //---

        result <<< """
            # see docs at https://github.com/realm/SwiftLint

            """

        result <<< sections

        //---

        fileContent = result.content
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
        var sections: [TextFileSection<SwiftLint>] = [

            .disabledRules(
                setXCEDefaults: setXCEDefaults,
                disabledRules
            ),
            .included(
                setXCEDefaults: setXCEDefaults,
                include
            ),
            .rulesOptions(
                setXCEDefaults: setXCEDefaults,
                rulesOptions
            )
        ]

        sections <<< (exclude.isEmpty).mapIf(false){

            .excluded(
                setXCEDefaults: setXCEDefaults,
                exclude
            )
        }

        sections <<< otherEntries.map{

            .custom($0)
        }

        //---

        return .init(sections: sections)
    }
}

// MARK: - Content rendering

public
extension TextFileSection
    where
    Context == SwiftLint
{
    static
    func disabledRules(
        setXCEDefaults: Bool = true,
        _ otherDisabledRules: [String] = []
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
    func included(
        setXCEDefaults: Bool = true,
        _ otherInclude: [String] = []
        ) -> TextFileSection<Context>
    {
        return .init{

            indentation in

            //---

            let result: IndentedTextBuffer = .init(with: indentation)

            //---

            result <<< """

                included: # paths to include during linting. `--path` is ignored if present.
                """

            indentation.nest{

                result <<< setXCEDefaults.mapIf(true){ """
                    - Sources
                    - Tests
                    """
                }

                result <<< otherInclude.map{ """
                    - \($0)
                    """
                }
            }

            //---

            return result.content
        }
    }

    static
    func excluded(
        setXCEDefaults: Bool = true,
        _ otherExclude: [String] = []
        ) -> TextFileSection<Context>
    {
        return .init{

            indentation in

            //---

            let result: IndentedTextBuffer = .init(with: indentation)

            //---

            result <<< """

                excluded: # paths to ignore during linting. Takes precedence over `included`.
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
        setXCEDefaults: Bool = true,
        _ otherRulesOptions: [SwiftLint.RuleOption] = []
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

            let i = indentation.singleLevel //swiftlint:disable:this identifier_name

            result <<< setXCEDefaults.mapIf(true){

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

    static
    func custom(
        _ customEntry: String
        ) -> TextFileSection<Context>
    {
        return .init(
            contentGetter: """

                \(customEntry)
                """
                .asIndentedText
            )
    }
}
