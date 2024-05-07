//
//  Constants.swift
//  TikTok
//
//  Created by Terry Jason on 2024/4/17.
//

import Firebase


// MARK: - Firebase Database Ref

let USER_DB_REF = Database.database().reference().child(K.FDatabase.users)

// MARK: - K

enum K {
    
    // MARK: - Storyboard
    
    enum Storyboard {
        static let main = "Main"
    }
    
    // MARK: - Identifier
    
    enum Identifier {
        static let signUpVC = "SignUpVC"
        static let signInVC = "SignInVC"
        static let authVC = "AuthVC"
        static let tabBarVC = "TabBarVC"
        static let previewVC = "PreviewCaptureVC"
    }
    
    // MARK: - Navbar
    
    enum NavbarTitle {
        static let createAccount = "Create new account"
        static let signIn = "Sign In"
    }
    
    // MARK: - Placeholder
    
    enum Placeholder {
        static let username = "Username"
        static let email = "Email"
        static let password = "Password"
    }
    
    // MARK: - Alert Title
    
    enum AlertTitle {
        static let signUpError = "Registration Error"
        static let signInError = "Sign In Error"
        static let emailVerifyTitle = "Email Verification"
        static let resendEmail = "Resend email"
        static let discardClip = "Discard the last clip?"
    }
    
    // MARK: - Alert Message
    
    enum AlertMessage {
        static let emailVerifyMessage = "We've just sent a confirmation email to your email address. Please check your inbox and click the verification link in that email to complete the sign up."
        static let checkEmailMessage = "You haven't confirmed your email address yet. We sent you a confirmation email wh en you sign up. Please click the verification link in that email. If you need us t o send the confirmation email again, please tap Resend Email."
    }
    
    // MARK: - Alert Action
    
    enum AlertAction {
        static let ok = "OK"
        static let cancel = "Cancel"
        static let discard = "Discard"
        static let keep = "Keep"
    }
    
    // MARK: - init
    
    enum initText {
        static let deinitText = "PreviewCaptureVideoVC was deineted"
    }
    
    // MARK: - ProgressHUD
    
    enum ProgressHUD {
        static let noAvatar = "Avatar has been added yet"
        static let loading = "Loading..."
    }
    
    // MARK: - Content Type
    
    enum ContentType {
        static let jpg = "image/jpg"
        static let mp4 = ".mp4"
    }
    
    // MARK: - Firebase Database Ref
    
    enum FDatabase {
        static let users = "users"
    }
    
    // MARK: - Firebase Storage Ref
    
    enum FStorage {
        static let profileImages = "profile-images"
    }
    
    // MARK: - User
    
    enum UserInfo {
        static let uid = "uid"
        static let username = "username"
        static let email = "email"
        static let profileImageUrl = "profileImageUrl"
        static let status = "status"
    }
    
}
