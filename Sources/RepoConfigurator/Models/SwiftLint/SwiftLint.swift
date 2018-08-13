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

    //internal
    struct DisabledRules
    {
        let setXCEDefaults: Bool
        let otherDisabledRules: [String]
    }

    //internal
    struct Exclude
    {
        let setXCEDefaults: Bool
        let otherExclude: [String]
    }

    //internal
    struct RulesOptions
    {
        let setXCEDefaults: Bool
        let otherRulesOptions: [RuleOption]
    }

    // MARK: - Instance level members

    public private(set)
    var fileContent: [IndentedTextGetter] = []

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
        fileContent <<< """
            # see docs at https://github.com/realm/SwiftLint

            """

        fileContent <<< DisabledRules(
            setXCEDefaults: defaultXCESettings,
            otherDisabledRules: disabledRules
        )

        fileContent <<< Exclude(
            setXCEDefaults: defaultXCESettings,
            otherExclude: exclude
        )

        fileContent <<< RulesOptions(
            setXCEDefaults: defaultXCESettings,
            otherRulesOptions: rulesOptions
        )

        fileContent <<< otherEntries.map{

            """

            \($0)
            """
        }
    }
}

// MARK: - Content rendering

extension SwiftLint.DisabledRules: TextFilePiece
{
    func asIndentedText(
        with indentation: inout Indentation
        ) -> IndentedText
    {
        var result: IndentedText = []

        //---

        result = """

            disabled_rules:

            """
            .asIndentedText(with: &indentation)

        result <<< setXCEDefaults.mapIf(true, or: []){

            """
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

        result <<< otherDisabledRules.map{

            """
                - \($0)
            """
            .asIndentedText(with: &indentation)
        }

        //---

        return result
    }
}

extension SwiftLint.Exclude: TextFilePiece
{
    func asIndentedText(
        with indentation: inout Indentation
        ) -> IndentedText
    {
        var result: IndentedText = []

        //---

        result = """

            # paths to ignore during linting. Takes precedence over `included`.
            excluded:

            """
            .asIndentedText(with: &indentation)

        result <<< setXCEDefaults.mapIf(true, or: []){

            """
                - Resources
                - Carthage
                - Pods
            """
            .asIndentedText(with: &indentation)
        }

        result <<< otherExclude.map{

            """
                - \($0)
            """
            .asIndentedText(with: &indentation)
        }

        //---

        return result
    }
}

extension SwiftLint.RulesOptions: TextFilePiece
{
    func asIndentedText(
        with indentation: inout Indentation
        ) -> IndentedText
    {
        var result: IndentedText = []

        //---

        result <<< """

            # rules options:

            """
            .asIndentedText(with: &indentation)

        result <<< setXCEDefaults.mapIf(true, or: []){

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
            .asIndentedText(with: &indentation)
        }

        result <<< otherRulesOptions.map{

            // NOTE: NO extra indentation!

            """
            \($0.rule):
                \($0.option): \($0.value)
            """
            .asIndentedText(with: &indentation)
        }

        //---

        return result
    }
}
