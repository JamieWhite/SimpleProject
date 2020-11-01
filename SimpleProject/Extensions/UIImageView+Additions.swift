import UIKit
import AlamofireImage

extension UIImageView {
    
    func jw_setImage(url: URL, placeholderImage: UIImage? ,runImageTransitionIfCached: Bool = false) {
        af.setImage(withURL: url, placeholderImage: placeholderImage, imageTransition: .crossDissolve(0.3), runImageTransitionIfCached: false)
    }
    
}
