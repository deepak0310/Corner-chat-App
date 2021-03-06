//
//  UIImage+Extension.swift
//  Corner
//
//  Created by MobileGod on 01/02/2017.
//  Copyright © 2017 BSE. All rights reserved.
//

import UIKit

extension UIImage {
	
	class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
		let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
		UIGraphicsBeginImageContextWithOptions(size, false, 0)
		color.setFill()
		UIRectFill(rect)
		let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		return image
	}
	
}
