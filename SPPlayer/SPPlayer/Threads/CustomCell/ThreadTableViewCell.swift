//
//  ThreadTableViewCell.swift
//  SPPlayer
//
//  Created by Ethan Chen on 11/21/18.
//  Copyright © 2018 Estamp. All rights reserved.
//

import UIKit

class ThreadTableViewCell: UITableViewCell {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var trackImg: UIImageView!
    @IBOutlet weak var threadMsg: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
