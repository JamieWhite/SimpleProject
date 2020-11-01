import UIKit

extension UIColor {
    
    convenience init(red255: CGFloat, green255: CGFloat, blue255: CGFloat) {
        self.init(red: red255/255.0, green: green255/255.0, blue: blue255/255.0, alpha: 1.0)
    }
    
}
