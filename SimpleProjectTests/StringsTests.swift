import XCTest

@testable import SimpleProject

final class StringsTests: XCTestCase {

    func testCurrency() {
        XCTAssertEqual("£20.01", "20.01".asCurrency()!)
    }

}
