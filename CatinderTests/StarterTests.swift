import XCTest
@testable import Catinder

final class StarterCatinderTests: XCTestCase {
    @MainActor func testFixtureCyclesOffline() async throws {
        let service = FixtureCatService()
        let first = try await service.nextCat(breedID: nil)
        let second = try await service.nextCat(breedID: nil)
        XCTAssertEqual([first.id, second.id], ["milo", "luna"])
    }
}
