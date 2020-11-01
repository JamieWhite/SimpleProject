import XCTest

@testable import SimpleProject

final class APIManagerTests: XCTestCase {
    
    func testExecute() {
        let products = [Product(title: "Hello", description: "description", listPrice: "10.00", images: [:])]
        let mockAPIManagerSession = StubbedAPIManagerSession()
        mockAPIManagerSession.mockProducts = products
        
        let expectation = XCTestExpectation(description: "Load API results")
        
        let apiManager = APIManager(urlSession: mockAPIManagerSession)
        apiManager.execute(Product.all) { result in
            switch result {
            case .success(let resultProducts):
                XCTAssertEqual(resultProducts, products)
            case .failure:
                XCTFail()
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
}
