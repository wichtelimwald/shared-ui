import XCTest
@testable import SharedUI

/// Smoke test: SharedUI module imports and links.
///
/// The previous tests in `shared-ui/Tests/AssistanceKitTests/` belong to the
/// spun-off siblings (coverflow, markdown-ui). New tests for Backgrounds,
/// Buttons, Compatibility, Styles should be added here.
final class SharedUITests: XCTestCase {
    func testModuleImports() {
        XCTAssertTrue(true, "SharedUI links")
    }
}
