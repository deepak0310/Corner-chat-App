//
//  StoreSettingInfoTableViewCell.swift
//  Corner
//
//  Created by MobileGod on 31/01/2017.
//  Copyright © 2017 BSE. All rights reserved.
//

import UIKit
import SwiftyJSON

class StoreSettingInfoTableViewCell: UITableViewCell {

	@IBOutlet weak var imgAvatar:	UIImageView!
	@IBOutlet weak var lblStoreName:UILabel!
	@IBOutlet weak var lblAddress1: UILabel!
	@IBOutlet weak var lblAddress2: UILabel!
	@IBOutlet weak var lblPhoneNum: UILabel!
	@IBOutlet weak var btnEdit: UIButton!
	
	let colorLabel = UIColor(red: 199, green: 199, blue: 205)
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		lblStoreName.font = UIFont(name: "AvenirNext-DemiBold", size: 20)
		lblStoreName.textColor = UIColor(red: 74, green: 74, blue: 74)
		
		lblAddress1.font = UIFont(name: "AvenirNext-Regular", size: 17)
		lblAddress1.textColor = UIColor(red: 74, green: 74, blue: 74)
		
		lblAddress2.font = UIFont(name: "AvenirNext-Regular", size: 17)
		lblAddress2.textColor = UIColor(red: 74, green: 74, blue: 74)
		
		lblPhoneNum.font = UIFont(name: "AvenirNext-Regular", size: 17)
		lblPhoneNum.textColor = UIColor(red: 74, green: 74, blue: 74)
		
		btnEdit.setTitleColor(Color.AppLightGreen, for: .normal)
    }
    
    func setupCell() {
        guard let user = DataManager.shared.currentUser else { return }
        guard let shopOid = user.shop?.oid else { return }
        let ref = "/users/\(shopOid)/"
        IssuesManager.shared.firebaseReference.child(ref).observeSingleEvent(of: .value, with: {[weak self] (snapshot) in
            guard let strongSelf = self else { return }
            let value = snapshot.value as? NSDictionary
            let json = JSON(value)
            strongSelf.lblStoreName.text = json["shop_name"].stringValue
            strongSelf.lblAddress1.text = json["address1"].stringValue
            strongSelf.lblAddress2.text = json["address2"].stringValue
            strongSelf.lblPhoneNum.text = json["phone"].stringValue
            
        }) { (error) in
            print(error.localizedDescription)
        }


    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
