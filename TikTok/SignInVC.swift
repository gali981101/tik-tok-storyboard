//
//  SignInVC.swift
//  TikTok
//
//  Created by Terry Jason on 2024/4/17.
//

import UIKit
import ProgressHUD
import FirebaseAuth
import IQKeyboardManagerSwift

final class SignInVC: UIViewController {
    
    // MARK: - Properties
    
    private var vm = SignInVM()
    
    // MARK: - @IBOulet
    
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            emailTextField.tag = 1
            emailTextField.returnKeyType = .next
        }
    }
    
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.tag = 2
            passwordTextField.isSecureTextEntry = true
            passwordTextField.textContentType = .oneTimeCode
            passwordTextField.returnKeyType = .done
        }
    }
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var passwordContainerView: UIView!
    
}

// MARK: - Life Cycle

extension SignInVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        configTextFieldObserver()
    }
    
}

// MARK: - Set

extension SignInVC {
    
    private func setUp() {
        self.title = K.NavbarTitle.signIn
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        self.hideKeyboardWhenTappedAround()
        
        AuthService.shared.delegate = self
        
        emailContainerView.layer.borderWidth = 1
        emailContainerView.layer.cornerRadius = 20
        
        emailContainerView.layer.borderColor = CGColor(
            red: 217/255,
            green: 217/255,
            blue: 217/255,
            alpha: 0.8
        )
        
        emailContainerView.clipsToBounds = true
        
        emailTextField.borderStyle = .none
        emailTextField.placeholder = K.Placeholder.email
        
        passwordContainerView.layer.borderWidth = 1
        passwordContainerView.layer.cornerRadius = 20
        
        passwordContainerView.layer.borderColor = CGColor(
            red: 217/255,
            green: 217/255,
            blue: 217/255,
            alpha: 0.8
        )
        
        passwordContainerView.clipsToBounds = true
        
        passwordTextField.borderStyle = .none
        passwordTextField.placeholder = K.Placeholder.password
        
        signInButton.layer.cornerRadius = 10
        signInButton.backgroundColor = .systemGreen.withAlphaComponent(0.5)
        signInButton.setTitleColor(UIColor(white: 1, alpha: 0.64), for: .normal)
        signInButton.isEnabled = false
        
        [emailTextField, passwordTextField]
            .forEach { $0.delegate = self }
    }
    
}

// MARK: - @IBAction

extension SignInVC {
    
    @IBAction func signInDidTapped(_ sender: Any) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        ProgressHUD.animate(K.ProgressHUD.loading)
        
        AuthService.shared.signInUser(with: email, password: password) { [unowned self] in
            ProgressHUD.dismiss()
            view.endEditing(true)
            
            let scene = UIApplication.shared.connectedScenes.first
            guard let sd: SceneDelegate = (scene?.delegate as? SceneDelegate) else { return }
            
            sd.configInitialVC()
        }
    }
    
}

// MARK: - @objc Actions

extension SignInVC {
    
    @objc private func textDidChange(sender: UITextField) {
        switch sender {
        case emailTextField:
            vm.email = sender.text
        case passwordTextField:
            vm.password = sender.text
        default:
            break
        }
        
        updateForm()
    }
    
}

// MARK: - Helper Methods

extension SignInVC {
    
    private func configTextFieldObserver() {
        [emailTextField, passwordTextField]
            .forEach { textField in
                textField?.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
            }
    }
    
}

// MARK: - FormVMDelegate

extension SignInVC: FormVMDelegate {
    
    func updateForm() {
        signInButton.isEnabled = vm.formIsValid
        signInButton.backgroundColor = vm.buttonBgColor
        signInButton.setTitleColor(vm.buttonTitleColor, for: .normal)
    }
    
}

// MARK: - AuthServiceDelegate

extension SignInVC: AuthServiceDelegate {
    
    func sendEmailVerifyAlert() {
        ProgressHUD.dismiss()
        
        let alert = UIAlertController(
            title: K.AlertTitle.signInError,
            message: K.AlertMessage.checkEmailMessage,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: K.AlertTitle.resendEmail, style: .default) { _ in
            Auth.auth().currentUser?.sendEmailVerification()
        }
        
        let cancelAction = UIAlertAction(title: K.AlertAction.cancel, style: .cancel)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
}

// MARK: - UITextFieldDelegate

extension SignInVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return string == " " ? false : true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 2 { view.endEditing(true) }
        
        if let nextTextField = view.viewWithTag(textField.tag + 1) {
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
        }
        
        return true
    }
    
}




