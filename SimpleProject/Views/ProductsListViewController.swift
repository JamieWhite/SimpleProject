import UIKit

final class ProductsListViewController: UIViewController {
    
    private let apiManager = APIManagerCached()
    private let viewModel = ProductsListViewModel()
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let refreshControl = UIRefreshControl()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private var products = [Product]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = LocalizedString(key: "products.title")
        
        tableView.jw_registerClassWithDefaultIdentifier(cellClass: ProductCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .tableBackground
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        tableView.dataSource = self
        tableView.delegate = self
        
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController?.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController?.searchResultsUpdater = self
        navigationItem.searchController?.searchBar.placeholder = LocalizedString(key: "products.search.placeholder")
        
        NotificationCenter.default.addObserver(self, selector: #selector(textSizeChanged), name: UIContentSizeCategory.didChangeNotification, object: nil)
        
        viewModel.delegate = self
        
        
        view.addSubview(tableView)
        tableView.addSubview(refreshControl)
        tableView.constrainToSuperview()
        
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectededRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectededRow, animated: true)
        }
    }
    
    @objc func textSizeChanged() {
        tableView.reloadData()
    }
    
    @objc func fetchData() {
        refreshControl.beginRefreshing()
        viewModel.refresh()
    }
    
    func showError() {
        /// Given more time I would've made an "ErrorViewController" with a retry button
        let alertController = UIAlertController(title: "", message: LocalizedString(key: "products.load.error.body"), preferredStyle: .alert)
        let alertAction = UIAlertAction(title: LocalizedString(key: "products.load.error.actionButton"), style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension ProductsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProductCell = tableView.jw_dequeueReusableCellWithDefaultIdentifier()
        
        let product = products[indexPath.row]
        cell.configure(product)
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension ProductsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = products[indexPath.row]
        let productDetailViewController = ProductDetailViewController(product: product)
        
        showDetailViewController(UINavigationController(rootViewController: productDetailViewController), sender: self)
    }
    
}

// MARK: - UISearchBarDelegate
extension ProductsListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchText = searchBar.text
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}

// MARK: - ProductsViewModelDelegate
extension ProductsListViewController: ProductsViewModelDelegate {
    
    func productsViewModelDidRefresh(result: Result<[Product], APIError>, animated: Bool) {
        refreshControl.endRefreshing()
        
        switch result {
        case .success(let products):
            self.products = products
        case .failure:
            showError()
        }
        
        if animated {
            tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        } else {
            tableView.reloadData()
        }
    }
    
}

// MARK: - UISearchResultsUpdating
extension ProductsListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchText = searchController.searchBar.text
    }
    
}
