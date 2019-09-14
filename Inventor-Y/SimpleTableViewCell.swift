//
//  SimpleTableViewCell.swift
//  Inventor-Y
//
//  Created by Muhammad Faisal Imran Khan on 2/18/18.
//  Copyright © 2018 MI Apps. All rights reserved.
//

import UIKit

class SimpleTableViewCell: UITableViewCell {

    
    @IBOutlet weak var thumbnail_view: UIImageView!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
