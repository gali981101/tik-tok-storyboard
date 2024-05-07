//
//  SignUpVC.swift
//  TikTok
//
//  Created by Terry Jason on 2024/4/17.
//

import UIKit
import PhotosUI
import ProgressHUD
import IQKeyboardManagerSwift

final class SignUpVC: UIViewController {
    
    // MARK: - Properties
    
    private var vm = SignUpVM()
    private var profileImage: UIImage?
    
    // MARK: - @IBOulet
    
    @IBOutlet weak var avatar: UIImageView! {
        didSet {
            avatar.layer.cornerRadius = avatar.frame.width / 2
            avatar.layer.masksToBounds = true
            avatar.isUserInteractionEnabled = true
        }
    }
    
    @IBOutlet weak var usernameTextField: UITextField! {
        didSet {
            usernameTextField.tag = 1
            usernameTextField.returnKeyType = .next
            usernameTextField.becomeFirstResponder()
        }
    }
    
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            emailTextField.tag = 2
            emailTextField.returnKeyType = .next
        }
    }
    
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.tag = 3
            passwordTextField.isSecureTextEntry = true
            passwordTextField.textContentType = .oneTimeCode
            passwordTextField.returnKeyType = .done
        }
    }
    
    @IBOutlet weak var usernameContainerView: UIView!
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var passwordContainerView: UIView!
    
    @IBOutlet weak var signUpButton: UIButton!
    
}

// MARK: - Life Cycle

extension SignUpVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        configTextFieldObserver()
    }
    
}

// MARK: - Set

extension SignUpVC {
    
    private func setUp() {
        self.title = K.NavbarTitle.createAccount
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        self.hideKeyboardWhenTappedAround()
        
        AuthService.shared.delegate = self
        
        usernameContainerView.layer.borderWidth = 1
        usernameContainerView.layer.cornerRadius = 20
        
        usernameContainerView.layer.borderColor = CGColor(
            red: 217/255,
            green: 217/255,
            blue: 217/255,
            alpha: 0.8
        )
        
        usernameContainerView.clipsToBounds = true
        
        usernameTextField.borderStyle = .none
        usernameTextField.placeholder = K.Placeholder.username
        
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
        
        signUpButton.layer.cornerRadius = 10
        signUpButton.backgroundColor = .systemGreen.withAlphaComponent(0.5)
        signUpButton.isEnabled = false
        
        [usernameTextField, emailTextField, passwordTextField]
            .forEach { $0.delegate = self }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        avatar.addGestureRecognizer(tapGesture)
    }
    
}

// MARK: - @IBActions

extension SignUpVC {
    
    @IBAction func signUpDidTapped(_ sender: Any) {
        guard let username = usernameTextField.text else { return }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        guard let profileImage = self.profileImage else {
            ProgressHUD.failed(K.ProgressHUD.noAvatar)
            return
        }
        
        let credentials = AuthCredentials(
            username: username,
            email: email,
            password: password,
            profileImage: profileImage
        )
        
        ProgressHUD.animate(K.ProgressHUD.loading)
        
        AuthService.shared.registerUser(withCredential: credentials) { [unowned self] in
            ProgressHUD.dismiss()
            view.endEditing(true)
        }
    }
    
}

// MARK: - @objc Actions

extension SignUpVC {
    
    @objc private func textDidChange(sender: UITextField) {
        switch sender {
        case usernameTextField:
            vm.username = sender.text
        case emailTextField:
            vm.email = sender.text
        case passwordTextField:
            vm.password = sender.text
        default:
            break
        }
        
        updateForm()
    }
    
    @objc private func presentPicker() {
        var configuration = PHPickerConfiguration()
        
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        
        ProgressHUD.animate(K.ProgressHUD.loading)
        present(picker, animated: true)
    }
    
}

// MARK: - Helper Methods

extension SignUpVC {
    
    private func configTextFieldObserver() {
        [usernameTextField, emailTextField, passwordTextField]
            .forEach { textField in
                textField?.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
            }
    }
    
}

// MARK: - FormVMDelegate

extension SignUpVC: FormVMDelegate {
    
    func updateForm() {
        signUpButton.isEnabled = vm.formIsValid
        signUpButton.backgroundColor = vm.buttonBgColor
        signUpButton.setTitleColor(vm.buttonTitleColor, for: .normal)
    }
    
}

// MARK: - AuthServiceDelegate

extension SignUpVC: AuthServiceDelegate {
    
    func sendEmailVerifyAlert() {
        let alert = UIAlertController(
            title: K.AlertTitle.emailVerifyTitle,
            message: K.AlertMessage.emailVerifyMessage,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: K.AlertAction.ok, style: .cancel) { [unowned self] _ in
            
            let storyboard = UIStoryboard(name: K.Storyboard.main, bundle: nil)
            let signInVC = storyboard.instantiateViewController(withIdentifier: K.Identifier.signInVC) as! SignInVC
            
            navigationController?.pushViewController(signInVC, animated: true)
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
}


// MARK: - UITextFieldDelegate

extension SignUpVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return string == " " ? false : true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 3 { view.endEditing(true) }
        
        if let nextTextField = view.viewWithTag(textField.tag + 1) {
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
        }
        
        return true
    }
    
}

// MARK: - PHPickerViewControllerDelegate

extension SignUpVC: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        ProgressHUD.dismiss()
        
        let itemProviders = results.map(\.itemProvider)
        
        guard let itemProvider = itemProviders.first,
              itemProvider.canLoadObject(ofClass: UIImage.self) else { return }
        
        itemProvider.loadObject(ofClass: UIImage.self) { [unowned self] (image, error) in
            DispatchQueue.main.async { [unowned self] in
                guard let image = image as? UIImage else { return }
                avatar.image = image
                profileImage = image
            }
        }
    }
    
}




