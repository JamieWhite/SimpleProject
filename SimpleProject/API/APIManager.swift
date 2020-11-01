import Foundation

enum APIError: Error {
    case networkError
    case parsingError
}

/// Build the URL
extension URL {
    func url(with queryItems: [URLQueryItem]) -> URL {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        components.queryItems = (components.queryItems ?? []) + queryItems
        return components.url!
    }
    
    init<Value>(_ host: String, _ request: Request<Value>) {
//        let queryItems = [ ("page", 750) ]
//        .map { name, value in URLQueryItem(name: name, value: "\(value)") }
        
        let url = URL(string: host)!
            .appendingPathComponent(request.path)
            .url(with: request.queryItems)
//            .url(with: queryItems)
        
        self.init(string: url.absoluteString)!
    }
}

// MARK: - APIManagerSession
protocol APIManagerSession {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: APIManagerSession {}

// MARK: -  APIManager
class APIManager {
    
    private let host = "https://interview.tasks.consolegfx.net/api/products/v2.0"
    
    private let urlSession: APIManagerSession
    
    init(urlSession: APIManagerSession = SessionManager.sessionManager) {
        self.urlSession = urlSession
    }
    
    func execute<Value: Codable>(_ request: Request<Value>,
                                   completionQueue: DispatchQueue = .main,
                                   completion: @escaping (Result<Value, APIError>) -> Void) {
        
        print("\(request.method.rawValue) \(host)\(request.path) - into: \(String(describing:  Value.self))")
        
        urlSession.dataTask(with: urlRequest(for: request)) { responseData, response, _ in
            if let data = responseData {
                let apiResponse: APIResponse<Value>
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    apiResponse = try decoder.decode(APIResponse<Value>.self, from: data)
                } catch (let error) {
                    print("Parsing error: \(error)")
                    completionQueue.async {
                        completion(.failure(.parsingError))
                    }
                    return
                }
                
                completionQueue.async {
                    completion(.success(apiResponse.data))
                }
            } else {
                completionQueue.async {
                    completion(.failure(.networkError))
                }
            }
        }.resume()
    }
    
    private func urlRequest<Value>(for request: Request<Value>) -> URLRequest {
        let url = URL(host, request)
        var result = URLRequest(url: url)
        result.httpMethod = request.method.rawValue
        result.httpBody = request.body
        return result
    }
    
}
