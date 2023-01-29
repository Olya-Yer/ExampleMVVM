import UIKit
import RxSwift
import RxCocoa

class RegistrationViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailValidityLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordValidityLabel: UILabel!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var ageValidityLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    
    private weak var coordinator: AuthCoordinator?
    private var viewModel = RegistrationViewModel()
    private var disposeBag = DisposeBag()
    
    func configure(coordinator: AuthCoordinator) {
        self.coordinator = coordinator
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindOutputs()
        bindInputs()
    }
    
    func bindInputs() {
        emailTextField.rx.text
            .bind(to: viewModel.inputs.login)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .bind(to: viewModel.inputs.password)
            .disposed(by: disposeBag)
        
        ageTextField.rx.text
            .bind(to: viewModel.inputs.age)
            .disposed(by: disposeBag)
        
        registerButton.rx.tap
            .bind(to: viewModel.inputs.auth)
            .disposed(by: disposeBag)
    }
    
    func bindOutputs() {
        viewModel.outputs.login
            .drive(emailTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.isEmailValid
            .drive { [weak self] isValid in
                guard let isValid = isValid else {
                    self?.emailValidityLabel.text = ""
                    return
                }
                self?.emailValidityLabel.text = isValid ? "√" : "not Valid"
                self?.emailValidityLabel.textColor = isValid ? .green : .red
            }
            .disposed(by: disposeBag)
        
        viewModel.outputs.password
            .drive(passwordTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.isPasswordValid
            .drive { [weak self] isValid in
                guard let isValid = isValid else {
                    self?.passwordValidityLabel.text = ""
                    return
                }
                self?.passwordValidityLabel.text = isValid ? "√" : "not Valid"
                self?.passwordValidityLabel.textColor = isValid ? .green : .red
            }
            .disposed(by: disposeBag)
        
        viewModel.outputs.age
            .debug("age")
            .drive(ageTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.isAgeValid
            .drive { [weak self] isValid in
                guard let isValid = isValid else {
                    self?.ageValidityLabel.text = ""
                    return
                }
                self?.ageValidityLabel.text = isValid ? "√" : "not Valid"
                self?.ageValidityLabel.textColor = isValid ? .green : .red
            }
            .disposed(by: disposeBag)
        
        viewModel.outputs.isRegistrationEnabled
            .drive(registerButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.outputs.auth
            .emit(onNext: { [weak self] in
                self?.coordinator?.goHome()
            })
            .disposed(by: disposeBag)
    }
    
    
    @IBAction func handleLogin(_ sender: Any) {
        coordinator?.goToLogin()
    }
}
