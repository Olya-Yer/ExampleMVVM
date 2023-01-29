import Foundation
import UIKit

class HomeCoordinator {
    weak var appCoordinator: Coordinator?
    
    init(appCoordinator: Coordinator) {
        self.appCoordinator = appCoordinator
    }
    
    func start() -> UIViewController {
        let homeViewController = HomeViewController(nibName: "HomeViewController", bundle: nil)
        homeViewController.configure(coordinator: self)
        return homeViewController
    }
    
    func logout() {
        appCoordinator?.goToLogin()
    }
    
    func showPostDetails(post: PostItem) {
        let postDetailsViewController = PostDetailsViewController(nibName: "PostDetailsViewController", bundle: nil)
        postDetailsViewController.configure(post: post)
        appCoordinator?.navigationController?.pushViewController(postDetailsViewController, animated: true)
    }

}
