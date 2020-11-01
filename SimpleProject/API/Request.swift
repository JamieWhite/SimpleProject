import Foundation

enum Method: String {
    case get = "GET"
}

struct Request<Value> {
    
    let method: Method
    let path: String
    let queryItems: [URLQueryItem]
    let body: Data?
    
    init(method: Method = .get, path: String, queryItems: [URLQueryItem] = [], body: Data? = nil) {
        self.method = method
        self.path = path
        self.queryItems = queryItems
        self.body = body
    }
    
}
