//
//  UIView+Extension.swift
//  bitmal
//
//  Created by User on 25/10/2019.
//  Copyright © 2019 Logicon. All rights reserved.
//

import UIKit

extension UIView {
    
    func setBorder(borderWidth: CGFloat, borderCgColor: CGColor? = nil, cornerRadius: CGFloat? = nil) {
        self.layer.borderWidth = borderWidth
        if let borderCgColor = borderCgColor {
            self.layer.borderColor = borderCgColor
        } else {
            self.layer.borderColor = UIColor.clear.cgColor
        }
        if let cornerRadius = cornerRadius {
            self.layer.cornerRadius = cornerRadius
        }
        self.clipsToBounds = true
    }
    
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float, cornerRadius: CGFloat) {
        layer.masksToBounds = false
        layer.cornerRadius = cornerRadius
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
}
