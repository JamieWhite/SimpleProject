import XCTest

@testable import SimpleProject

// MARK: - MockAPIManagerReachability
final class MockAPIManagerReachability: APIManagerReachability {
    
    var mockIsReachable: Bool
    
    init(mockIsReachable: Bool) {
        self.mockIsReachable = mockIsReachable
    }
    
    var isNotReachable: Bool {
        return !mockIsReachable
    }
}

// MARK: - MockAPIManagerCachedStorage
final class MockAPIManagerCachedStorage: APIManagerCachedStorage {
    
    var storedProducts = [Product]()
    
    func storeToCache<T: Encodable>(_ object: T, as fileName: String) {
        storedProducts = object as! [Product]
    }
    
    func retrieveFromCache<T: Decodable>(_ fileName: String, as type: T.Type) -> T {
        return storedProducts as! T
    }
}

// MARK: - APIManagerCachedTests
final class APIManagerCachedTests: XCTestCase {
    
    func testCanStoreInCache() {
        let products = [Product(title: "Hello", description: "description", listPrice: "10.00", images: [:])]

        let mockAPIManagerCachedStorage = MockAPIManagerCachedStorage()
        let mockAPIManagerReachability = MockAPIManagerReachability(mockIsReachable: true)

        let mockAPIManagerSession = StubbedAPIManagerSession()
        mockAPIManagerSession.mockProducts = products

        let apiManagerCache = APIManagerCached(storage: mockAPIManagerCachedStorage, networkStatus: mockAPIManagerReachability, storageDispatchQueue: .main, urlSession: mockAPIManagerSession)

        // Verify we have nothing loaded by testing offline first
        let firstExpectation = XCTestExpectation(description: "First load offline")
        mockAPIManagerReachability.mockIsReachable = false
        apiManagerCache.execute(CachedRequest(request: Product.all, fileName: "testFileName")) { result in
            switch result {
            case .success(let resultProducts):
                XCTAssertEqual(resultProducts, [])
            case .failure:
                XCTFail()
            }
            
            firstExpectation.fulfill()
        }
        
        wait(for: [firstExpectation], timeout: 1.0)

        // Test online next
        let secondExpectation = XCTestExpectation(description: "Second load online")
        mockAPIManagerReachability.mockIsReachable = true
        apiManagerCache.execute(CachedRequest(request: Product.all, fileName: "testFileName")) { result in
            switch result {
            case .success(let resultProducts):
                XCTAssertEqual(resultProducts, products)
            case .failure:
                XCTFail()
            }
            
            secondExpectation.fulfill()
        }
        
        wait(for: [secondExpectation], timeout: 1.0)

        // Now go offline and verify we've got the cached results
        let thirdExpectation = XCTestExpectation(description: "Third load offline")
        mockAPIManagerReachability.mockIsReachable = false
        apiManagerCache.execute(CachedRequest(request: Product.all, fileName: "testFileName")) { result in
            switch result {
            case .success(let resultProducts):
                XCTAssertEqual(resultProducts, products)
            case .failure:
                XCTFail()
            }
            
            thirdExpectation.fulfill()
        }
        
        wait(for: [thirdExpectation], timeout: 1.0)

    }
    
}
