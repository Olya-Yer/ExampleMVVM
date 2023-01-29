import Foundation
import RxSwift

class RxFeedRepository {
    private let feedRepository: FeedRepository
    init() {
        self.feedRepository = FeedRepositoryImpl()
    }
}

extension RxFeedRepository: ReactiveCompatible {
    func load() -> Observable<PostPage> {
        return Observable.create { [feedRepository] observer in
            feedRepository.load { result, error in
                if let result = result {
                    observer.onNext(result)
                    observer.onCompleted()
                }
                if let error = error {
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}


protocol FeedRepository {
    func load(completion: @escaping (PostPage?, Error?) -> Void)
}

class FeedRepositoryImpl: FeedRepository {
    var network: NetworkManager
    let decoder = FeedDecoder()
    
    init(network: NetworkManager = .init()) {
        self.network = network
    }
    
    func load(completion: @escaping (PostPage?, Error?) -> Void){
        let parameters = [
            "key": "33207930-a0857342968f8e826808fb050",
            
        ]
        
        network.request(fromURL: "https://pixabay.com/api/", httpMethod: .get, paramenters: parameters) { [decoder] result in
            switch result {
            case let .success(data):
                let feed = decoder.decode(data: data)
                completion(feed, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }
}
