import Foundation

// MARK: - ProductsViewModelDelegate
protocol ProductsViewModelDelegate: AnyObject {
    func productsViewModelDidRefresh(result: Result<[Product], APIError>, animated: Bool)
}

// MARK: - ProductsAPIManagerProtocol
protocol ProductsAPIManagerProtocol {
    func execute<Value: Codable>(_ request: CachedRequest<Value>, completionQueue: DispatchQueue, completion: @escaping (Result<Value, APIError>) -> Void)
}

extension APIManagerCached: ProductsAPIManagerProtocol {}

// MARK: - ProductsViewModel
final class ProductsListViewModel {
    
    weak var delegate: ProductsViewModelDelegate?
    
    private let apiManager: ProductsAPIManagerProtocol
    
    private let cachFileName = "productsFeed"
    
    init(apiManager: ProductsAPIManagerProtocol = APIManagerCached()) {
        self.apiManager = apiManager
    }
    
    var searchText: String? {
        didSet {
            if let searchTerm = searchText, !searchTerm.isEmpty {
                let filteredProducts = products.filter { $0.title.lowercased().contains(searchTerm.lowercased())}
                delegate?.productsViewModelDidRefresh(result: .success(filteredProducts), animated: false)
            } else {
                delegate?.productsViewModelDidRefresh(result: .success(products), animated: false)
            }
        }
    }
    
    private(set) var products = [Product]()
    
    func refresh() {
        apiManager.execute(CachedRequest(request: Product.all, fileName: cachFileName), completionQueue: .main) { [weak self] result in
            switch result {
            case .success(let products):
                self?.products = products
                
                if let searchTerm = self?.searchText, !searchTerm.isEmpty {
                    let filteredProducts = products.filter { $0.title.contains(searchTerm)}
                    self?.delegate?.productsViewModelDidRefresh(result: .success(filteredProducts), animated: true)
                } else {
                    self?.delegate?.productsViewModelDidRefresh(result: result, animated: true)
                }
                
            case .failure:
                self?.delegate?.productsViewModelDidRefresh(result: result, animated: true)
            }
        }
    }
    
}
