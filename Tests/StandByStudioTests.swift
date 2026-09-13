import XCTest
@testable import StandByStudio

final class StandByStudioTests: XCTestCase {
    func testCatalogContainsUniqueIdentifiers() {
        let identifiers = StandByWidgetDescriptor.catalog.map(\.id)
        XCTAssertEqual(Set(identifiers).count, identifiers.count)
    }

    func testCatalogShipsWithThreeWidgets() {
        XCTAssertEqual(StandByWidgetDescriptor.catalog.count, 3)
    }

    func testCatalogDescriptionsAreComplete() {
        for widget in StandByWidgetDescriptor.catalog {
            XCTAssertFalse(widget.name.isEmpty)
            XCTAssertFalse(widget.summary.isEmpty)
            XCTAssertFalse(widget.symbol.isEmpty)
            XCTAssertGreaterThanOrEqual(widget.colors.count, 2)
        }
    }
}
