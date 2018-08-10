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
struct SwiftLint: FixedNameTextFile, ConfigurableTextFile
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

    public
    enum Section: TextFilePiece
    {
        case defaultHeader

        case disabledRules(
            setXCEDefaults: Bool,
            otherDisabledRules: [String]
        )

        case excluded(
            excludeResources: Bool,
            excludeDependencies: Bool,
            customExclude: [String]
        )

        case rulesOptions(
            setXCEDefaults: Bool,
            otherRulesOptions: [RuleOption]
        )

        case custom(String)
    }

    // MARK: - Instance level members

    public
    var fileContent: IndentedText = []

    // MARK: - Initializers

    public
    init() {}
}

// MARK: - Presets

public
extension SwiftLint
{
    public
    static
    func defaultXCE(
        otherDisabledRules: [String] = [],
        excludeResources: Bool = true,
        excludeDependencies: Bool = true,
        customExclude: [String] = [],
        otherRulesOptions: [RuleOption] = []
        ) -> SwiftLint
    {
        return .init(
            .defaultHeader,
            .disabledRules(
                setXCEDefaults: true,
                otherDisabledRules: otherDisabledRules
            ),
            .excluded(
                excludeResources: excludeResources,
                excludeDependencies: excludeDependencies,
                customExclude: customExclude
            ),
            .rulesOptions(
                setXCEDefaults: true,
                otherRulesOptions: otherRulesOptions
            )
        )
    }
}

// MARK: - Content rendering

public
extension SwiftLint.Section
{
    func asIndentedText(
        with indentation: inout Indentation
        ) -> IndentedText
    {
        var result: IndentedText = []

        //---

        switch self
        {
        case .defaultHeader:
            result = """

                # see more at https://github.com/realm/SwiftLint

                # ===
                """
                .asIndentedText(with: &indentation)

        case .disabledRules(
            let setXCEDefaults,
            let otherDisabledRules
            ):
            result = """

                disabled_rules:

                """
                .asIndentedText(with: &indentation)

            indentation++

            if
                setXCEDefaults
            {
                result <<< """
                    - function_parameter_count
                    - trailing_newline
                    - closure_parameter_position
                    - opening_brace
                    - nesting
                    - function_body_length
                    - file_length
                    """
                    .asIndentedText(with: &indentation)
            }

            otherDisabledRules.forEach{

                result <<< """
                    - \($0)
                    """
                    .asIndentedText(with: &indentation)
            }

            indentation--

        case .excluded(
            let excludeResources,
            let excludeDependencies,
            let customExclude
            ):
            result = """

                    # paths to ignore during linting. Takes precedence over `included`.
                    excluded:

                    """
                    .asIndentedText(with: &indentation)

            indentation++

            if
                excludeResources
            {
                result <<< """
                    - Resources
                    """
                    .asIndentedText(with: &indentation)
            }

            if
                excludeDependencies
            {
                result <<< """
                    - Carthage
                    - Pods
                    """
                    .asIndentedText(with: &indentation)
            }

            customExclude.forEach{

                result <<< """
                    - \($0)
                    """
                    .asIndentedText(with: &indentation)
            }

            indentation--

        case .rulesOptions(
            let setXCEDefaults,
            let otherRulesOptions
            ):
            result = """

                # rules options:

                """
                .asIndentedText(with: &indentation)

            if
                setXCEDefaults
            {
                // NOTE: without extra indentation!

                result <<< """
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
                    .asIndentedText(with: &indentation)
            }

            otherRulesOptions.forEach{

                // NOTE: without extra indentation!

                result <<< """
                    \($0.rule):
                        \($0.option): \($0.value)
                    """
                    .asIndentedText(with: &indentation)
            }

        case .custom(
            let customEntry
            ):
            result = """

                \(customEntry)
                """
                .asIndentedText(with: &indentation)
        }

        //---

        return result
    }
}
