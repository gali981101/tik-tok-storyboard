//
//  AuthService.swift
//  TikTok
//
//  Created by Terry Jason on 2024/4/19.
//

import UIKit
import Firebase
import FirebaseAuth
import ProgressHUD

struct AuthCredentials {
    let username: String
    let email: String
    let password: String
    let profileImage: UIImage
}

// MARK: - AuthServiceDelegate

protocol AuthServiceDelegate: AnyObject {
    func sendEmailVerifyAlert()
}

// MARK: - AuthService

final class AuthService {
    
    // MARK: - Properties
    
    static let shared: AuthService = AuthService()
    weak var delegate: AuthServiceDelegate?
    
    // MARK: - Init
    
    private init() {}
    
}

// MARK: - Log In

extension AuthService {
    
    func signInUser(with email: String, password: String, completion: @escaping () -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [unowned self] result, error in
            if let error = error {
                ProgressHUD.failed(error.localizedDescription)
                return
            }
            
            guard let result = result, result.user.isEmailVerified else {
                delegate?.sendEmailVerifyAlert()
                return
            }
            
            completion()
        }
    }
    
}

// MARK: - Log Out

extension AuthService {
    
    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            ProgressHUD.failed(error.localizedDescription)
            return
        }
        
        let scene = UIApplication.shared.connectedScenes.first
        guard let sd: SceneDelegate = (scene?.delegate as? SceneDelegate) else { return }
        
        sd.configInitialVC()
    }
    
}

// MARK: - Register

extension AuthService {
    
    func registerUser(withCredential credentials: AuthCredentials, completion: @escaping () -> Void) {
        
        let username = credentials.username
        let email = credentials.email
        let password = credentials.password
        
        StorageService.uploadImage(image: credentials.profileImage) { imageUrl in
            
            Auth.auth().createUser(withEmail: email, password: password) { [unowned self] result, error in
                if error != nil {
                    ProgressHUD.failed(error?.localizedDescription)
                    return
                }
                
                sendEmailVerify()
                
                guard let uid = result?.user.uid else { return }
                
                let data: [String: Any] = [
                    K.UserInfo.uid: uid,
                    K.UserInfo.username: username,
                    K.UserInfo.email: email,
                    K.UserInfo.profileImageUrl: imageUrl,
                    K.UserInfo.status: ""
                ]
                
                USER_DB_REF.child(uid).setValue(data)
            }
            
            completion()
        }
    }
    
}

// MARK: - Email Verify

extension AuthService {
    
    private func sendEmailVerify() {
        Auth.auth().currentUser?.sendEmailVerification(completion: { [unowned self] error in
            guard error == nil else { fatalError() }
            delegate?.sendEmailVerifyAlert()
        })
    }
    
}

