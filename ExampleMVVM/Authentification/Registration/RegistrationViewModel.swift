import Foundation
import RxSwift
import RxCocoa

class RegistrationViewModel {
    struct Inputs {
        var login: BehaviorSubject<String?> = BehaviorSubject(value: nil)
        var password: BehaviorSubject<String?> = BehaviorSubject(value: nil)
        var age: BehaviorSubject<String?> = BehaviorSubject(value: nil)
        var auth: PublishSubject<Void> = PublishSubject()
    }
    
    struct Outputs {
        var login: Driver<String?> = .never()
        var isEmailValid: Driver<Bool?> = .never()
        var password: Driver<String?> = .never()
        var isPasswordValid: Driver<Bool?> = .never()
        var age: Driver<String?> = .never()
        var isAgeValid: Driver<Bool?> = .never()
        var auth: Signal<Void> = .never()
        var isRegistrationEnabled: Driver<Bool> = .never()
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
        outputs.password = inputs.password.asDriver(onErrorJustReturn: "")
        let age = inputs.age
            .map { ageString -> Int? in
                guard let ageString = ageString else { return nil }
                return Int(ageString)
            }
            .startWith(nil)
            .asDriver(onErrorJustReturn: nil)
        
        outputs.isEmailValid = inputs.login
            .map { [weak self] in self?.isValidEmail($0) }
            .asDriver(onErrorJustReturn: false)
        
        outputs.isPasswordValid = inputs.password
            .map { password -> Bool? in
                guard let password = password, !password.isEmpty else { return nil }
                return password.count > 5 && password.count < 13
            }
            .asDriver(onErrorJustReturn: false)
        
        outputs.isAgeValid = age
            .map { age -> Bool? in
                guard let age = age else { return nil }
                return age > 17 && age < 100
            }
            .asDriver(onErrorJustReturn: false)
        
        outputs.age = age
            .map { ageInt in
                guard let ageInt = ageInt else { return "" }
                return String(ageInt)
            }
            .asDriver(onErrorJustReturn: "")
        
        outputs.isRegistrationEnabled = Observable.combineLatest(
            outputs.isEmailValid.asObservable(),
            outputs.isPasswordValid.asObservable(),
            outputs.isAgeValid.asObservable()
        )
            .map { isLoginValid, isPasswordValid, isAgeValid in
                guard let isLoginValid = isLoginValid,
                      let isPasswordValid = isPasswordValid,
                      let isAgeValid = isAgeValid else { return false}
                return isLoginValid && isPasswordValid && isAgeValid
            }
            .asDriver(onErrorJustReturn: false)
        
        outputs.auth = inputs.auth
            .withLatestFrom(
                Observable.combineLatest(
                    inputs.login.asObservable(),
                    inputs.password.asObservable(),
                    age.asObservable()
                )
            )
            .flatMapLatest({ login, password, age -> Observable<Bool> in
                dependencies.authRepository.register(email: login ?? "", password: password ?? "", age: age ?? 0)
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


extension String {
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
}
