import XCTest

@testable import SimpleProject

// MARK: - MockProductsAPIManager
final class MockProductsAPIManager: ProductsAPIManagerProtocol {
    
    var mockProducts: [Product]
    
    init(mockProducts: [Product]) {
        self.mockProducts = mockProducts
    }
    
    func execute<Value: Codable>(_ request: CachedRequest<Value>, completionQueue: DispatchQueue, completion: @escaping (Result<Value, APIError>) -> Void) {
        completion(.success(mockProducts as! Value))
    }
    
}

// MARK: - ProductsViewModelDelegateStandin
final class ProductsViewModelDelegateStandin: ProductsViewModelDelegate {
    
    var products = [Product]()
    
    func productsViewModelDidRefresh(result: Result<[Product], APIError>, animated: Bool) {
        if case .success(let products) = result {
            self.products = products
        }
    }
    
}

// MARK: - ProductsViewModelTests
final class ProductsViewModelTests: XCTestCase {

    func testRefreshLoadsProducts() {
        let mockProducts = [Product(title: "Hello", description: "Description", listPrice: "10.00", images: [:])]
        let mockProductsAPIManager = MockProductsAPIManager(mockProducts: mockProducts)
        let productsViewModel = ProductsListViewModel(apiManager: mockProductsAPIManager)
        productsViewModel.refresh()
        
        XCTAssertEqual(mockProducts, productsViewModel.products)
    }
    
    func testProductSearch() {
        let mockProducts = [Product(title: "Hello", description: "Description", listPrice: "10.00", images: [:]),
        Product(title: "Bye", description: "Description 2", listPrice: "11.00", images: [:])]
        
        let mockProductsAPIManager = MockProductsAPIManager(mockProducts: mockProducts)
        let productsViewModel = ProductsListViewModel(apiManager: mockProductsAPIManager)
        let productsViewModelDelegate = ProductsViewModelDelegateStandin()
        productsViewModel.delegate = productsViewModelDelegate
        productsViewModel.refresh()
        
        // Verify before we search
        XCTAssertEqual(mockProducts, productsViewModelDelegate.products)
        XCTAssertEqual(2, productsViewModelDelegate.products.count)
        
        productsViewModel.searchText = "Hello"
        
        // Verify after search
        XCTAssertEqual([mockProducts[0]], productsViewModelDelegate.products)
        XCTAssertEqual(1, productsViewModelDelegate.products.count)
        
        // Reset search
        productsViewModel.searchText = ""
        
        XCTAssertEqual(mockProducts, productsViewModelDelegate.products)
        XCTAssertEqual(2, productsViewModelDelegate.products.count)
    }

}
