import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(FastlaneTests.allTests),
        testCase(SwiftLintTests.allTests)
    ]
}
#endif
