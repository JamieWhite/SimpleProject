import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var window: UIWindow? = {
        return UIWindow()
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let splitViewController = UISplitViewController()
        splitViewController.preferredDisplayMode = .oneBesideSecondary
        let productsListNavigationController = UINavigationController(rootViewController: ProductsListViewController())
        splitViewController.viewControllers = [productsListNavigationController]
        window?.rootViewController = splitViewController
        window?.makeKeyAndVisible()
        return true
    }

}

