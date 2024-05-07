//
//  AuthVM.swift
//  TikTok
//
//  Created by Terry Jason on 2024/4/18.
//

import UIKit

protocol FormVMDelegate {
    func updateForm()
}

protocol AuthVMDelegate {
    var formIsValid: Bool { get }
    var buttonBgColor: UIColor { get }
    var buttonTitleColor: UIColor { get }
}

extension AuthVMDelegate {
    var buttonBgColor: UIColor {
        return formIsValid ? .systemGreen : .systemGreen.withAlphaComponent(0.5)
    }
    
    var buttonTitleColor: UIColor {
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.64)
    }
}

struct SignInVM: AuthVMDelegate {
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
}

struct SignUpVM: AuthVMDelegate {
    var username: String?
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return username?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
    }
}

struct ResetPasswordVM: AuthVMDelegate {
    var email: String?
    var formIsValid: Bool { return email?.isEmpty == false }
}
