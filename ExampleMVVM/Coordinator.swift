import Foundation
import UIKit

class Coordinator {
    var navigationController: UINavigationController?
    private var authCoordinator: AuthCoordinator?
    private var homeCoordinator: HomeCoordinator?
    
    public func start() -> UINavigationController {
        let authCoordinator = AuthCoordinator(appCoordinator: self)
        self.homeCoordinator = HomeCoordinator(appCoordinator: self)
        self.authCoordinator = authCoordinator
        let loginVC = authCoordinator.start()
        let navController = UINavigationController(rootViewController: loginVC)
        self.navigationController = navController
        return navController
    }
    
    func goToLogin() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let authCoordinator = authCoordinator else { return }
        let newNav = UINavigationController(rootViewController: authCoordinator.start())
        navigationController = newNav
        appDelegate.setRootViewController(newNav)
    }
    
    func goHome() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let homeCoordinator = homeCoordinator else { return }
        let newNav = UINavigationController(rootViewController: homeCoordinator.start())
        navigationController = newNav
        appDelegate.setRootViewController(newNav)
    }
}
