import Foundation

/// Keep these types and the test service available to the app.
struct Cat: Codable, Equatable, Identifiable {
    let id: String
    let breedID: String
    let breedName: String
    let imageName: String
}

protocol CatService {
    func nextCat(breedID: String?) async throws -> Cat
}

enum FixtureFailure: Error { case unavailable }

/// Deterministic, offline data source. Each instance starts at the first cat.
@MainActor
final class FixtureCatService: CatService {
    static let cats = [
        Cat(id: "milo", breedID: "tabby", breedName: "Tabby", imageName: "cat.fill"),
        Cat(id: "luna", breedID: "siamese", breedName: "Siamese", imageName: "cat.fill"),
        Cat(id: "leo", breedID: "tabby", breedName: "Tabby", imageName: "cat.fill")
    ]
    private var indexByBreed: [String: Int] = [:]
    private var shouldFail: Bool
    init(failFirst: Bool = false) { shouldFail = failFirst }
    func nextCat(breedID: String?) async throws -> Cat {
        let isLoadingScenario = ProcessInfo.processInfo.environment["CATINDER_SCENARIO"] == "loading"
        try await Task.sleep(for: .seconds(isLoadingScenario ? 30 : 1))
        if shouldFail { shouldFail = false; throw FixtureFailure.unavailable }
        let cats = Self.cats.filter { breedID == nil || $0.breedID == breedID }
        guard !cats.isEmpty else { throw FixtureFailure.unavailable }
        let key = breedID ?? "all"
        let index = indexByBreed[key, default: 0]
        indexByBreed[key] = index + 1
        return cats[index % cats.count]
    }
}
