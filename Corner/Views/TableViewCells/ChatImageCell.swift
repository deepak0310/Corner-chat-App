//
//  ChatImageCell.swift
//  Corner
//
//  Created by Marco Cabazal on 04/27/2017.
//  Copyright © 2017 BSE. All rights reserved.
//

import UIKit

class ChatImageCell: MessageTableViewCell {
  
  @IBOutlet weak var chatImageView: UIImageView!
  
  override func awakeFromNib() {
      super.awakeFromNib()
  }
  
  required init?(coder aDecoder: NSCoder) {
    
    super.init(coder: aDecoder)
    self.selectionStyle = .none
    self.backgroundColor = UIColor.white
    self.bodyLabel.removeFromSuperview()
  }
  
}
