//
//  RoundCorner.swift
//  SPPlayerShare
//
//  Created by Ethan Chen on 11/18/18.
//  Copyright © 2018 Estamp. All rights reserved.
//

import UIKit

@IBDesignable public class RoundCorner: UIView {
    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
        }
    }
    
}
