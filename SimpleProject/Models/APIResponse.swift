import Foundation

struct APIResponse<T: Codable>: Codable {
    
    let meta: Meta
    let data: T

}

extension APIResponse {
    
    struct Meta: Codable {
        let offset: Int
        let limit: Int
        let count: Int
        let total: Int
    }
    
}
