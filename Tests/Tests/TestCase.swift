import XCTest

final class TestCase: XCTestCase {
    func test_sync() {
        sleep(1)
    }

    func test_async() async throws {
        try await Task.sleep(nanoseconds: 2_000_000_000)
    }
}
