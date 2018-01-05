//
//  SelShopTableViewCell.swift
//  Corner
//
//  Created by MobileGod on 26/01/2017.
//  Copyright © 2017 BSE. All rights reserved.
//

import UIKit

class SelShopTableViewCell: UITableViewCell {

	@IBOutlet weak var nameLabel:		UILabel!
	@IBOutlet weak var imgCheck:	UIImageView!
	
    @IBOutlet weak var lbl_address: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		nameLabel.textColor = UIColor.darkGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
