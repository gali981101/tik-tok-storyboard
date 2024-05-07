//
//  AlertFactory.swift
//  TikTok
//
//  Created by Terry Jason on 2024/4/19.
//

import UIKit

enum AlertFactory {
    
    static func makeOkAlert(title: String = K.AlertTitle.signUpError, message: String?) -> UIAlertController {
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: K.AlertAction.ok, style: .cancel)
        
        alert.addAction(okAction)
        
        return alert
    }
    
}
