//
//  StoreSettingNotificationTableViewCell.swift
//  Corner
//
//  Created by MobileGod on 31/01/2017.
//  Copyright © 2017 BSE. All rights reserved.
//

import UIKit

class StoreSettingNotificationTableViewCell: UITableViewCell {

	@IBOutlet weak var lblTitle: UILabel!
	@IBOutlet weak var swtOption: UISwitch!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		lblTitle.font = UIFont(name: "AvenirNext-Regular", size: 15)
		lblTitle.textColor = UIColor(red: 74, green: 74, blue: 74)
		
		swtOption.onTintColor = Color.AppLightGreen
		swtOption.tintColor = Color.AppLightGreen
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
