//
//  UIViewController+Extension.swift
//  Corner
//
//  Created by MobileGod on 24/01/2017.
//  Copyright © 2017 BSE. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

//
// MARK: Extension Of UIViewController
///
////

let screenSize = UIScreen.main.bounds.size
let customerStoryboard = UIStoryboard(name: "Customer", bundle: nil)
let shopStoryboard = UIStoryboard(name: "Shop", bundle: nil)

private let btnAddPhotoBGColor = UIColor.init(red: 216, green: 216, blue: 216)
private let btnTextColor = UIColor.init(red: 135, green: 135, blue: 134)

extension UIViewController {
	
	public func Log(_ log: String) {
		print("➣   " + log)
	}
	
	public func initAddPhotoButton(_ button: UIButton) {
		
		button.isEnabled = true
		button.setBackgroundImage(nil, for: .normal)
		button.setImage(nil, for: .normal)
		button.backgroundColor = btnAddPhotoBGColor
		button.setTitle("Add\nPhoto", for: .normal)
		button.setTitleColor(btnTextColor, for: .normal)
		button.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 12.0)
		button.titleLabel?.numberOfLines = 2
	}
	
	public func setImageAddPhotoButton(for button: UIButton, selImage: UIImage) {
		
		button.isEnabled = false
		button.setBackgroundImage(nil, for: .normal)
		button.setImage(selImage, for: .normal)
	}
}
