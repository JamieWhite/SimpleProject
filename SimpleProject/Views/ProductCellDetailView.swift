import UIKit

final class ProductCellDetailView: UIView {
    
    private let labelStackView: UIStackView = {
        let labelStackView = UIStackView()
        labelStackView.spacing = Margin.large
        labelStackView.axis = .vertical
        return labelStackView
    }()
    
    private let spacerView: UIView = {
        let spacerView = UIView()
        spacerView.backgroundColor = .cellBackground
        return spacerView
    }()
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .title
        titleLabel.textColor = .titleText
        titleLabel.numberOfLines = 3
        titleLabel.backgroundColor = .cellBackground
        return titleLabel
    }()
    
    let priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.font = .body
        priceLabel.textColor = .bodyText
        priceLabel.backgroundColor = .cellBackground
        return priceLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutMargins = UIEdgeInsets(all: Margin.small)
        
        // Add views
        addSubview(labelStackView)
        labelStackView.jw_addArrangedSubviews(titleLabel, spacerView, priceLabel)
        
        // Constraints
        labelStackView.constrainToSuperviewMargins()
        spacerView.setContentHuggingPriority(.defaultLow, for: .vertical)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }

}
