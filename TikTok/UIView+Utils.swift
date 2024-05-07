//
//  UIView+Utils.swift
//  TikTok
//
//  Created by Terry Jason on 2024/4/26.
//

import UIKit

extension UIView {
    
    func constraintToLeft(paddingLeft: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let left = superview?.leftAnchor {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
    }
    
}
