import Foundation
import UIKit

class AuthCoordinator {
    weak var appCoordinator: Coordinator?
    
    init(appCoordinator: Coordinator) {
        self.appCoordinator = appCoordinator
    }
    
    func start() -> UIViewController {
        let loginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
        loginViewController.configure(coordinator: self)
        return loginViewController
    }
    
    func goToLogin() {
        appCoordinator?.goToLogin()
    }
    
    func goToRegistration() {
        let regViewController = RegistrationViewController(nibName: "RegistrationViewController", bundle: nil)
        regViewController.configure(coordinator: self)
        appCoordinator?.navigationController?.pushViewController(regViewController, animated: true)
    }
    
    func goHome() {
        appCoordinator?.goHome()
    }
}
