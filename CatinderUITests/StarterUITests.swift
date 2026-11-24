import XCTest

final class CatinderUITests: XCTestCase {
    func testStarterApplicationLaunches() {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 10))
    }
}
