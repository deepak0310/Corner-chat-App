//
//  MessagesEmptyTableViewCell.swift
//  Corner
//
//  Created by MobileGod on 02/02/2017.
//  Copyright © 2017 BSE. All rights reserved.
//

import UIKit

class MessagesEmptyTableViewCell: UITableViewCell {

	@IBOutlet weak var lblMessage: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		
		let attributedString = NSMutableAttributedString(string: "Once you send a message, it goes to shops around you. Then, BAM! They respond here, and you’ll find what you’re looking for - faster.")
		attributedString.addAttribute(NSKernAttributeName, value: CGFloat(-0.7), range: NSRange(location: 0, length: attributedString.length))
		
		let fasterRange = NSRange(location: attributedString.length - 7, length: 6)
//		attributedString.addAttribute(NSFontAttributeName, value: "AvenirNext-DemiBoldItalic", range: fasterRange)
		attributedString.addAttribute(NSForegroundColorAttributeName, value: Color.AppLightGreen, range: fasterRange)
		
		lblMessage.attributedText = attributedString
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
