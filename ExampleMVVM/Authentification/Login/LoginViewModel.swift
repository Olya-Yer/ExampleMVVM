import Foundation
import RxSwift
import RxCocoa

class LoginViewModel {
    struct Inputs {
        var login: BehaviorSubject<String?> = BehaviorSubject(value: nil)
        var password: BehaviorSubject<String?> = BehaviorSubject(value: nil)
        var auth: PublishSubject<Void> = PublishSubject()
    }
    
    struct Outputs {
        var login: Driver<String?> = .never()
        var isLoginValid: Driver<Bool?> = .never()
        var password: Driver<String?> = .never()
        var isPasswordValid: Driver<Bool?> = .never()
        var auth: Signal<Void> = .never()
        var isLoginEnabled: Driver<Bool> = .never()
    }
    
    var inputs = Inputs()
    var outputs = Outputs()
    
    struct Dependencies {
        let authRepository: AuthRepository
    }
    
    var dependencies: Dependencies
    
    init(dependencies: Dependencies = .init(authRepository: AuthRepositoryImpl())) {
        self.dependencies = dependencies
        outputs.login = inputs.login.asDriver(onErrorJustReturn: "")
        
        outputs.isLoginValid = inputs.login
            .map { [unowned self] in isValidEmail($0) }
            .asDriver(onErrorJustReturn: false)
        
        outputs.isPasswordValid = inputs.password
            .map { password -> Bool? in
                guard let password = password, !password.isEmpty else { return nil }
                return password.count > 5 && password.count < 13
            }
            .asDriver(onErrorJustReturn: false)
        
        outputs.isLoginEnabled = Observable.combineLatest(outputs.isLoginValid.asObservable(), outputs.isPasswordValid.asObservable())
            .map { isLoginValid, isPasswordValid in
                guard let isLoginValid = isLoginValid, let isPasswordValid = isPasswordValid else { return false}
                return isLoginValid && isPasswordValid
            }
            .asDriver(onErrorJustReturn: false)
        
        outputs.auth = inputs.auth
            .withLatestFrom(
                Observable.combineLatest(inputs.login.asObservable(), inputs.password.asObservable())
            )
            .flatMapLatest({ login, password -> Observable<Bool> in
                dependencies.authRepository.login(email: login ?? "", password: password ?? "")
            })
            .filter { $0 }
            .map { _ in Void() }
        .asSignal(onErrorJustReturn: ())
    }
    
    private func isValidEmail(_ email: String?) -> Bool? {
        guard let email = email, !email.isEmpty else { return nil }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
