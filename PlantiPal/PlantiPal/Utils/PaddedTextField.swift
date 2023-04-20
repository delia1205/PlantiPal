//
//  PaddedTextField.swift
//  PlantiPal
//
//  Created by Delia on 17/03/2023.
//  Copyright © 2023 Delia. All rights reserved.
//

import UIKit
class PaddedTextField: UITextField {
    
    @IBInspectable var paddingLeft: CGFloat = 10
    @IBInspectable var paddingRight: CGFloat = 10
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + paddingLeft, y: bounds.origin.y,
                      width: bounds.size.width - paddingLeft - paddingRight, height: bounds.size.height);
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
}
