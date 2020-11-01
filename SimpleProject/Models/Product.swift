import Foundation

struct Product: Codable, Equatable {
    
    let title: String
    let description: String
    let listPrice: String
    let images: [String: Image?]
}

extension Product {
    
    static var all: Request<[Product]> {
        return Request(method: .get, path: "/products", queryItems: [URLQueryItem(name: "image_sizes[]", value: "750")])
    }
    
}

extension Product {
    
    struct Image: Codable, Equatable {
        let src: String
        let url: URL
        let width: Int
    }
    
}
