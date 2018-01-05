//
//  MyMessageTableViewCell.swift
//  Corner
//
//  Created by MobileGod on 25/01/2017.
//  Copyright © 2017 BSE. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class MyMessageTableViewCell: MGSwipeTableCell {
    
    @IBOutlet var imgAvatar:	UIImageView!
    @IBOutlet var lblChatText:  UILabel!
    @IBOutlet var lblDate:		UILabel!
    @IBOutlet var imgUnread:    UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.init(red: 249, green: 249, blue: 249)
        self.imgAvatar.backgroundColor = .clear
        self.lblDate.textColor = .lightGray
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
