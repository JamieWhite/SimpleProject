import Foundation

import Reachability

// Wrapper for Reachability
final class NetworkStatus {
    
    private let reachability: Reachability
    
    init() {
        reachability = try! Reachability()
    }
    
    var isReachable: Bool {
        return reachability.connection != .unavailable
    }
    
    var isNotReachable: Bool {
        return reachability.connection == .unavailable
    }
}
