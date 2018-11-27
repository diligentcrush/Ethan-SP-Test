//
//  CircleView.swift
//  SPPlayer
//
//  Created by Ethan Chen on 11/22/18.
//  Copyright © 2018 Estamp. All rights reserved.
//

import UIKit

class CircleView: UILabel {

    var cornerRadius: CGFloat = 35
    

    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true

    }
    
}
