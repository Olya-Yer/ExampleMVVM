import Foundation
import RxCocoa
import RxDataSources

class HomeViewModel {
    
    struct Outputs {
        var posts: Driver<[FeedSection]> = .never()
    }
    
    struct Dependencies {
        let feedRepository: RxFeedRepository // TODO: Fix to work with the protocol
    }
    
    let dependenices: Dependencies
    var outputs = Outputs()
    
    init(dependenices: Dependencies = .init(feedRepository: RxFeedRepository())) {
        self.dependenices = dependenices
        
        let postPage = dependenices.feedRepository.load()
        
        outputs.posts = postPage
            .debug("items")
            .map { postPage in
            postPage.posts
        }
        .map{ [FeedSection(items: $0)] }
        .asDriver(onErrorJustReturn: [])
    }
}

struct FeedSection {
    var items: [PostItem]
}

extension FeedSection: SectionModelType {
    typealias Item = PostItem
    
    init(original: FeedSection, items: [PostItem]) {
        self = original
        self.items = items
    }
}
