//
//  ShopTableViewCell.swift
//  Corner
//
//  Created by MobileGod on 25/01/2017.
//  Copyright © 2017 BSE. All rights reserved.
//

import UIKit

class ShopTableViewCell: UITableViewCell {

	@IBOutlet weak var viewBorder:		UIView!
	@IBOutlet weak var imgAvatar:		UIImageView!
	@IBOutlet weak var nameLabel:			UILabel!
	@IBOutlet weak var streetLabel:	UILabel!
	@IBOutlet weak var cityLabel:		UILabel!
	@IBOutlet weak var imgContact:		UIImageView!
	@IBOutlet weak var blockedImage:		UIImageView!
	@IBOutlet weak var favedImage:		UIImageView!
	@IBOutlet weak var contactButton:		UIButton!
	@IBOutlet weak var faveButton:		UIButton!
	@IBOutlet weak var blockButton:		UIButton!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		self.backgroundColor = UIColor.clear
		
		viewBorder.setRoundedBorder(cornerRadius: 6.0, borderWidth: 1, borderColor: UIColor.lightGray)
		imgAvatar.setCornerRadius(cornerRadius: 3.0)
        blockButton.isHidden = true
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
}
