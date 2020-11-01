import UIKit

extension UIView {
    
    /// Constrain view to all superview edges
    @discardableResult func constrainToSuperview(activate shouldActivate: Bool = true) -> [NSLayoutConstraint] {
        guard let superview = superview else {
            fatalError("No superview")
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            topAnchor.constraint(equalTo: superview.topAnchor)
        ]
        
        if shouldActivate {
            NSLayoutConstraint.activate(constraints)
        }

        return constraints
    }
    
    /// Constrain view to all superview margins
    @discardableResult func constrainToSuperviewMargins(activate shouldActivate: Bool = true) -> [NSLayoutConstraint] {
        guard let superview = superview else {
            fatalError("No superview")
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            leadingAnchor.constraint(equalTo: superview.layoutMarginsGuide.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.layoutMarginsGuide.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.layoutMarginsGuide.bottomAnchor),
            topAnchor.constraint(equalTo: superview.layoutMarginsGuide.topAnchor)
        ]
        
        if shouldActivate {
            NSLayoutConstraint.activate(constraints)
        }

        return constraints
    }
    
    /// Constrains view to size
    @discardableResult func constrainTo(size: CGSize, activate shouldActivate: Bool = true) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            widthAnchor.constraint(equalToConstant: size.width),
            heightAnchor.constraint(equalToConstant: size.height)
        ]
        
        if shouldActivate {
            NSLayoutConstraint.activate(constraints)
        }

        return constraints
    }
    
    /// Constrains view to width with maximum height
    @discardableResult func constrainTo(width: CGFloat, maxHeight: CGFloat, activate shouldActivate: Bool = true) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            widthAnchor.constraint(equalToConstant: width),
            heightAnchor.constraint(lessThanOrEqualToConstant: maxHeight)
        ]
        
        if shouldActivate {
            NSLayoutConstraint.activate(constraints)
        }

        return constraints
    }
    
}
