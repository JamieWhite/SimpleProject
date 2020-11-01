import Foundation

// MARK: - APIManagerCachedStorage
protocol APIManagerCachedStorage {
    func storeToCache<T: Encodable>(_ object: T, as fileName: String)
    func retrieveFromCache<T: Decodable>(_ fileName: String, as type: T.Type) -> T
}

extension Storage: APIManagerCachedStorage {}

// MARK: - APIManagerReachability
protocol APIManagerReachability {
    var isNotReachable: Bool { get }
}

extension NetworkStatus: APIManagerReachability {}

// MARK: - APIManagerCached

/// Caches API requests to disk
final class APIManagerCached: APIManager {
    
    private let storage: APIManagerCachedStorage
    private let networkStatus: APIManagerReachability
    
    /// Use this for serialising cache from disk
    private let storageDispatchQueue: DispatchQueue
    
    init(storage: APIManagerCachedStorage = Storage(),
         networkStatus: APIManagerReachability = NetworkStatus(),
         storageDispatchQueue: DispatchQueue = .global(qos: .background),
         urlSession: APIManagerSession = URLSession.shared) {
        
        self.storage = storage
        self.networkStatus = networkStatus
        self.storageDispatchQueue = storageDispatchQueue
        
        super.init(urlSession: urlSession)
    }
    
    func execute<Value: Codable>(_ request: CachedRequest<Value>,
                                 completionQueue: DispatchQueue = .main,
                                 completion: @escaping (Result<Value, APIError>) -> Void) {
        
        if networkStatus.isNotReachable {
            
            storageDispatchQueue.async { [weak self] in
                if let persistedValue = self?.persistedValue(fileName: request.fileName) as Value? {
                    
                    completionQueue.async {
                        completion(.success(persistedValue))
                    }
                    
                } else {
                    completionQueue.async {
                        completion(.failure(.networkError))
                    }
                }
            }

        } else {
            super.execute(request.request, completionQueue: completionQueue) { result in
                if case let .success(value) = result {
                    self.persist(value: value, fileName: request.fileName)
                }
                
                completion(result)
            }
        }
    }
    
    private func persist<Value: Codable>(value: Value, fileName: String) {
        storage.storeToCache(value, as: fileName)
    }
    
    private func persistedValue<Value: Codable>(fileName: String) -> Value? {
        return storage.retrieveFromCache(fileName, as: Value.self)
    }
    
}
