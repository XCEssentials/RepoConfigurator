import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(CocoaPodsTests.allTests),
        testCase(FastlaneTests.allTests),
        testCase(FrameworkConfigExample.allTests),
        testCase(SwiftLintTests.allTests),
        testCase(UtilsTests.allTests),
    ]
}
#endif
