//
//  ProfileVC.swift
//  TikTok
//
//  Created by Terry Jason on 2024/4/21.
//

import UIKit

final class ProfileVC: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - @IBOulet
    
}

// MARK: - Life Cycle

extension ProfileVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

// MARK: - @IBAction

extension ProfileVC {
    
    @IBAction func logOutAction(_ sender: Any) {
        AuthService.shared.logOut()
    }
    
}
