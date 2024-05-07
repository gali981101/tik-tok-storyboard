//
//  ViewController.swift
//  TikTok
//
//  Created by Terry Jason on 2024/4/17.
//

import UIKit

final class ViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - @IBOulet
    
    @IBOutlet weak var signUpButton: UIButton! {
        didSet {
            signUpButton.layer.cornerRadius = 18
        }
    }
    
    @IBOutlet weak var fbButton: UIButton! {
        didSet {
            fbButton.layer.cornerRadius = 18
        }
    }
    
    @IBOutlet weak var googleButton: UIButton! {
        didSet {
            googleButton.layer.cornerRadius = 18
        }
    }
    
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            loginButton.layer.cornerRadius = 18
        }
    }
    
}

// MARK: - Life Cycle

extension ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

// MARK: - @IBAction

extension ViewController {
    
    @IBAction func signUpDidTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: K.Storyboard.main, bundle: nil)
        let signUpVC = storyboard.instantiateViewController(withIdentifier: K.Identifier.signUpVC) as! SignUpVC
        
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @IBAction func signInDidTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: K.Storyboard.main, bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: K.Identifier.signInVC) as! SignInVC
        
        navigationController?.pushViewController(signInVC, animated: true)
    }
    
}




