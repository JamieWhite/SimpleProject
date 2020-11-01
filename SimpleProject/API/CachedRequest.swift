import Foundation

struct CachedRequest<Value> {
    
    let request: Request<Value>
    let fileName: String
    
}
