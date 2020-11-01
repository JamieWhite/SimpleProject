import UIKit

extension UITableViewCell {
    // swiftlint:disable:next identifier_name
    @objc static var jw_defaultIdentifier: String { return String(describing: self) }
}

extension UITableView {
    
    func jw_registerClassWithDefaultIdentifier(cellClass: AnyClass) {
        register(cellClass, forCellReuseIdentifier: cellClass.jw_defaultIdentifier)
    }
    
    func jw_dequeueReusableCellWithDefaultIdentifier<T: UITableViewCell>() -> T {
        // swiftlint:disable:next force_cast
        return dequeueReusableCell(withIdentifier: T.jw_defaultIdentifier) as! T
    }
    
}
