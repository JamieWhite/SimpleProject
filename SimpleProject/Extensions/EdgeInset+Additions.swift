import UIKit

extension UIEdgeInsets {
    
    /// Returns a UIEdgeInsets with all edges the same
    init(all: CGFloat) {
        self.init(top: all, left: all, bottom: all, right: all)
    }

}
