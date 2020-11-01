import UIKit

extension UIColor {
    
    static var titleText: UIColor {
        return darkGray
    }
    
    static var bodyText: UIColor {
        return gray
    }
    
    static var cellBackground: UIColor {
        return UIColor(red255: 255, green255: 254, blue255: 255)
    }
    
    static var cellBorder: UIColor {
        return UIColor(red255: 210, green255: 213, blue255: 216)
    }

    static var tableBackground: UIColor {
        return UIColor(red255: 244, green255: 246, blue255: 249)
    }
    
    static var ketchup: UIColor {
        return UIColor(red255: 235, green255: 51, blue255: 61)
    }
    
    static var detailBackgroundColour: UIColor {
        return UIColor(red255: 254, green255: 254, blue255: 254)
    }
    
}

extension UIFont {
    
    static var title: UIFont {
        return preferredFont(forTextStyle: .headline)
    }
    
    static var body: UIFont {
        return preferredFont(forTextStyle: .body)
    }
   
}
