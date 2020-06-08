//
//  PocketTableViewCell.swift
//  CryptoTradeSimulator
//
//  Created by Kuba on 24/05/2020.
//  Copyright © 2020 Kuba. All rights reserved.
//

import UIKit

class PocketTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
