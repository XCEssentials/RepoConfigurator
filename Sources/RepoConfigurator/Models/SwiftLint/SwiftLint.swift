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

    struct Section
    {
        public private(set)
        var content: [IndentedTextGetter] = []
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

        fileContent <<< Section.disabledRules(
            setXCEDefaults: defaultXCESettings,
            disabledRules
        )

        fileContent <<< Section.exclude(
            setXCEDefaults: defaultXCESettings,
            exclude
        )

        fileContent <<< Section.rulesOptions(
            setXCEDefaults: defaultXCESettings,
            rulesOptions
        )

        fileContent <<< otherEntries.map{

            """

            \($0)
            """
        }
    }
}

// MARK: - Content rendering

extension SwiftLint.Section: TextFilePiece
{
    public
    func asIndentedText(
        with indentation: Indentation
        ) -> IndentedText
    {
        return content.asIndentedText(with: indentation)
    }
}

extension SwiftLint.Section
{
    static
    func disabledRules(
        setXCEDefaults: Bool,
        _ otherDisabledRules: [String]
        ) -> SwiftLint.Section
    {
        var content: [IndentedTextGetter] = []

        //---

        content <<< """

            disabled_rules:

            """

        content <<< setXCEDefaults.mapIf(true){

            """
                - function_parameter_count
                - trailing_newline
                - closure_parameter_position
                - opening_brace
                - nesting
                - function_body_length
                - file_length
            """
        }

        content <<< otherDisabledRules.map{

            """
                - \($0)
            """
        }

        //---

        return .init(content: content)
    }

    static
    func exclude(
        setXCEDefaults: Bool,
        _ otherExclude: [String]
        ) -> Fastlane.Fastfile.Section
    {
        var content: [IndentedTextGetter] = []

        //---

        content <<< """

            # paths to ignore during linting. Takes precedence over `included`.
            excluded:

            """

        content <<< setXCEDefaults.mapIf(true){

            """
                - Resources
                - Carthage
                - Pods
            """
        }

        content <<< otherExclude.map{

            """
                - \($0)
            """
        }

        //---

        return .init(content: content)
    }

    static
    func rulesOptions(
        setXCEDefaults: Bool,
        _ otherRulesOptions: [SwiftLint.RuleOption]
        ) -> Fastlane.Fastfile.Section
    {
        var content: [IndentedTextGetter] = []

        //---

        content <<< """

            # rules options:

            """

        content <<< setXCEDefaults.mapIf(true){

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

        content <<< otherRulesOptions.map{

            // NOTE: NO extra indentation!

            """
            \($0.rule):
                \($0.option): \($0.value)
            """
        }

        //---

        return .init(content: content)
    }
}
