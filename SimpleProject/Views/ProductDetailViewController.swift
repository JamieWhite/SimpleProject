import UIKit

final class ProductDetailViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    private let paddedStackView: UIStackView = {
        let paddedStackView = UIStackView()
        paddedStackView.axis = .vertical
        paddedStackView.layoutMargins = UIEdgeInsets(all: Margin.large)
        paddedStackView.isLayoutMarginsRelativeArrangement = true
        paddedStackView.spacing = Margin.medium
        return paddedStackView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .title
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    
    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.font = .body
        descriptionLabel.numberOfLines = 0
        return descriptionLabel
    }()
    
    private let product: Product
    
    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .detailBackgroundColour
        stackView.axis = .vertical
        
        setupViewsHierarchy()
        setupConstraints()
        
        update(with: product)
    }
    
    private func update(with product: Product) {
        titleLabel.text = product.title
        descriptionLabel.text = product.description
        
        if let imageURL = product.images.values.first??.url {
            imageView.jw_setImage(url: imageURL, placeholderImage: Images.productPlaceholder)
        } else {
            imageView.image = Images.productPlaceholder
        }
    }
    
    private func setupViewsHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        stackView.jw_addArrangedSubviews(imageView, paddedStackView)
        paddedStackView.jw_addArrangedSubviews(titleLabel, descriptionLabel)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate(
            scrollView.constrainToSuperview(activate: false) +
            stackView.constrainToSuperview(activate: false) +
        [
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
}
