import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(UtilsTests.allTests),
        testCase(CocoaPodsTests.allTests),
        testCase(FastlaneTests.allTests),
        testCase(SwiftLintTests.allTests)
    ]
}
#endif
