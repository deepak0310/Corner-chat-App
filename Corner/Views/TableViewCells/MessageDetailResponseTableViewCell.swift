//
//  MessageDetailResponseTableViewCell.swift
//  Corner
//
//  Created by MobileGod on 26/01/2017.
//  Copyright © 2017 BSE. All rights reserved.
//

import UIKit

class MessageDetailResponseTableViewCell: UITableViewCell {

	
	@IBOutlet weak var imgShop:				UIImageView!
	@IBOutlet weak var imgUnread:			UIImageView!
	@IBOutlet weak var lblSellerName:		UILabel!
	@IBOutlet weak var lblShopName:			UILabel!
	@IBOutlet weak var lblDate:				UILabel!
	@IBOutlet weak var lblResponseMessage:	UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		imgUnread.backgroundColor = Color.AppBlue
		imgUnread.setCornerRadius(cornerRadius: imgUnread.frame.size.width/2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
