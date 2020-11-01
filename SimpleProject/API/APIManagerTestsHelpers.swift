import Foundation

// MARK: -  SessionManager

/// The only use for this is to stub out the sessions for UI tests
/// At the moment this is hard coded for products so not scalable to other calls
/// Could use a mock server embedded within the app to scale this further
final class SessionManager {
    
    static var sessionManager: APIManagerSession {
        if ProcessInfo.processInfo.arguments.contains("UI-TESTING") {
            
            let json = ProcessInfo.processInfo.environment["stubbedProducts"]
            let stubbedSesionManager = StubbedAPIManagerSession()
            stubbedSesionManager.mockJSON = json
            return stubbedSesionManager
        } else {
            return URLSession.shared
        }
    }
    
}

// MARKL - DummyURLSessionDataTask

/// Something for the StubbedAPIManagerSession to return
final class DummyURLSessionDataTask: URLSessionDataTask {
    override init() {}
}

final class StubbedAPIManagerSession: APIManagerSession {
    
    var mockProducts = [Product]()
    
    var mockJSON: String?
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        
        if let mockJSON = mockJSON  {
            completionHandler(mockJSON.data(using: .utf8), nil, nil)
        } else {
            let apiResponse = APIResponse(meta: APIResponse.Meta(offset: 0, limit: 0, count: 0, total: 0), data: mockProducts)
            let encoder = JSONEncoder()
            let data = try! encoder.encode(apiResponse)
            
            completionHandler(data, nil, nil)
        }
        
        return DummyURLSessionDataTask()
    }
    
}
