//
//  UIViewController+Utils.swift
//  TikTok
//
//  Created by Terry Jason on 2024/4/17.
//

import UIKit

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
}

// MARK: - @objc Methods

extension UIViewController {
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
