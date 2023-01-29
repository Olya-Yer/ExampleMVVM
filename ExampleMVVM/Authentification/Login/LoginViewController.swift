import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    @IBOutlet private var loginTextField: UITextField!
    @IBOutlet weak var loginValidityLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordValidityLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    var viewModel = LoginViewModel()
    var disposeBag = DisposeBag()
    private weak var coordinator: AuthCoordinator?
    
    func configure(coordinator: AuthCoordinator) {
        self.coordinator = coordinator
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindOutputs()
        bindInputs()
    }
    
    func bindInputs() {
        loginTextField.rx.text
            .bind(to: viewModel.inputs.login)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .bind(to: viewModel.inputs.password)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .bind(to: viewModel.inputs.auth)
            .disposed(by: disposeBag)
    }
    
    func bindOutputs() {
        viewModel.outputs.login
            .drive(loginTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.isLoginValid
            .drive { [weak self] isValid in
                guard let isValid = isValid else {
                    self?.loginValidityLabel.text = ""
                    return
                }
                self?.loginValidityLabel.text = isValid ? "√" : "not Valid"
                self?.loginValidityLabel.textColor = isValid ? .green : .red
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
        
        viewModel.outputs.isLoginEnabled
            .drive(loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.outputs.auth
            .emit(onNext: { [weak self] in
                self?.coordinator?.goHome()
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func handleRegister(_ sender: Any) {
        coordinator?.goToRegistration()
    }
}
