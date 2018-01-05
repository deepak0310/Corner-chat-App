//
//  SwitchTableViewCell.swift
//  Corner
//
//  Created by MobileGod on 26/01/2017.
//  Copyright © 2017 BSE. All rights reserved.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {

	@IBOutlet weak var swtView: UISwitch!
	@IBOutlet weak var lblAll:	UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		swtView.onTintColor = Color.AppLightGreen
		lblAll.textColor = UIColor.darkGray
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
