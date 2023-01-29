import Foundation
import RxSwift

protocol AuthRepository {
    func login(email: String, password: String) -> Observable<Bool>
    func register(email: String, password: String, age: Int) -> Observable<Bool>
}

class AuthRepositoryImpl: AuthRepository {
    func login(email: String, password: String) -> Observable<Bool> {
        return .just(true)
    }
    
    func register(email: String, password: String, age: Int) -> Observable<Bool> {
        return .just(true)
    }
}
