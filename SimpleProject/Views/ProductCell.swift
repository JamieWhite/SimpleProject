import UIKit

/// Shows a product with an image, title and price
final class ProductCell: UITableViewCell {
    
    private let productImageSize = CGSize(width: 100, height: 150)
    
    private let backgroundAndBorderView: UIView = {
        let backgroundAndBorderView = UIView()
        backgroundAndBorderView.layer.borderWidth = 1
        backgroundAndBorderView.layer.borderColor = UIColor.cellBorder.cgColor
        backgroundAndBorderView.backgroundColor = .cellBackground
        return backgroundAndBorderView
    }()
    
    private let containerStackView = UIStackView()
    
    private let productImage: UIImageView = {
        let productImage = UIImageView()
        productImage.image = UIImage(named: "productPlaceholder")
        productImage.contentMode = .scaleAspectFill
        productImage.clipsToBounds = true
        return productImage
    }()
    
    private let productDetailView = ProductCellDetailView()
    
    private let highlightView: UIView = {
        let highlightView = UIView()
        highlightView.backgroundColor = UIColor.gray.withAlphaComponent(0.6)
        highlightView.alpha = 0
        highlightView.isUserInteractionEnabled = false
        return highlightView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .tableBackground
        
        setupViewHierarchy()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("Not implemented")
    }
    
    private func setupViewHierarchy() {
        contentView.addSubview(backgroundAndBorderView)
        backgroundAndBorderView.addSubview(containerStackView)
        containerStackView.jw_addArrangedSubviews(productImage, productDetailView)
        
        backgroundAndBorderView.addSubview(highlightView)
    }
    
    private func setupConstraints() {
        backgroundAndBorderView.constrainToSuperviewMargins()
        containerStackView.constrainToSuperview()
        productImage.constrainTo(size: productImageSize)
        highlightView.constrainToSuperview()
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        UIView.animate(withDuration: animated ? 0.1 : 0.0) {
            self.highlightView.alpha = highlighted ? 0.8 : 0.0
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        UIView.animate(withDuration: animated ? 0.1 : 0.0) {
            self.highlightView.alpha = selected ? 1.0 : 0.0
        }
    }
    
    func configure(_ product: Product) {
        productDetailView.titleLabel.text = product.title
        productDetailView.priceLabel.text = product.listPrice.asCurrency()
        accessibilityValue = product.title
        accessibilityLabel = product.title
        
        if let imageURL = product.images.values.first??.url {
            productImage.jw_setImage(url: imageURL, placeholderImage: Images.productPlaceholder)
        }
    }
    
}
