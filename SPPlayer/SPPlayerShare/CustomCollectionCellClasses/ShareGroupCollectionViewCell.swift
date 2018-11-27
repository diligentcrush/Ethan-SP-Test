//
//  ShareGroupCollectionViewCell.swift
//  SPPlayerShare
//
//  Created by Ethan Chen on 11/18/18.
//  Copyright © 2018 Estamp. All rights reserved.
//

import UIKit

class ShareGroupCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
                self.contentView.backgroundColor = UIColor.lightGray
            }
            else
            {
                self.contentView.backgroundColor = UIColor.white
            }
        }
    }

}
