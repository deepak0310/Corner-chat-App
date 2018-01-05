//
//  CustomerMessageTableViewCell.swift
//  Corner
//
//  Created by MobileGod on 30/01/2017.
//  Copyright © 2017 BSE. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class CustomerMessageTableViewCell: MGSwipeTableCell {

	@IBOutlet weak var imgAvatar: UIImageView!
	@IBOutlet weak var lblDate: UILabel!
	@IBOutlet weak var lblCustomerName: UILabel!
	@IBOutlet weak var lblMessage: UILabel!
	@IBOutlet weak var lblCategory: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		imgAvatar.setCornerRadius(cornerRadius: imgAvatar.frame.size.width / 2)
		
		lblCustomerName.font = UIFont.init(name: "AvenirNext-DemiBold", size: 17)
		lblCustomerName.textColor = UIColor(red: 57, green: 57, blue: 57)
		
		lblMessage.font = UIFont.init(name: "AvenirNext-Regular", size: 15)
		lblMessage.numberOfLines = 2
		lblMessage.textColor = UIColor(red: 3, green: 3, blue: 3)
		
		lblDate.font = UIFont.init(name: "AvenirNext-Regular", size: 12)
		lblDate.textColor = UIColor(red: 143, green: 142, blue: 148)
		
		lblCategory.font = UIFont.init(name: "AvenirNext-Regular", size: 12)
		lblCategory.textColor = Color.AppLightGreen
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
}
