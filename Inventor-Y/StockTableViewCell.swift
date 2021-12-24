//
//  StockTableViewCell.swift
//  Inventor-Y
//
//  Created by Muhammad Faisal Imran Khan on 2/20/18.
//  Copyright © 2018 MI Apps. All rights reserved.
//

import UIKit

class StockTableViewCell: UITableViewCell {

    @IBOutlet weak var barcodeLabel: UILabel!
    
    @IBOutlet weak var barcodeDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
