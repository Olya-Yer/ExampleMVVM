import UIKit
import RxSwift
import RxDataSources

class HomeViewController: UIViewController {
    
    @IBOutlet weak var feedCollectionView: UICollectionView!
    
    private weak var coordinator: HomeCoordinator?
    private var viewModel = HomeViewModel()
    private var disposeBag = DisposeBag()
    
    lazy var dataSource = RxCollectionViewSectionedReloadDataSource<FeedSection> { feedDataSource, collectionView, indexPath, item in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCollectionViewCell", for: indexPath) as? FeedCollectionViewCell
        cell?.configure(imageURL: item.imageURL, userImageURL: item.userImageURL)
        // TODO: handle cell click
        return cell ?? UICollectionViewCell()
    }
    
    func configure(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedCollectionView.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: "FeedCollectionViewCell")
        feedCollectionView.register(UINib(nibName:"FeedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier:"FeedCollectionViewCell")
        
        if let layout = feedCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let itemWidth = view.bounds.width
            let itemHeight = layout.itemSize.height
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            layout.invalidateLayout()
        }
        
        bindOutputs()
        bindInputs()
    }
    
    func bindOutputs() {
        viewModel.outputs.posts
            .drive(feedCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    func bindInputs() {
        feedCollectionView.rx.modelSelected(PostItem.self)
                .subscribe(onNext: { [weak self] post in
                    self?.coordinator?.showPostDetails(post: post)
                }).disposed(by: disposeBag)
    }
    
    @IBAction func handleLogout(_ sender: Any) {
        coordinator?.logout()
    }
}
