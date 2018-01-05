//
//  UIView+Extension.swift
//  Corner
//
//  Created by MobileGod on 24/01/2017.
//  Copyright © 2017 BSE. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
	
	fileprivate func setShadow(offset: CGFloat, radius: CGFloat, opacity: Float) {
		
		self.layer.shadowOffset = CGSize(width: 0, height: offset)
		self.layer.shadowRadius = radius
		self.layer.shadowColor = UIColor.black.cgColor
		self.layer.shadowOpacity = opacity
	}
	
	func setCornerRadius(cornerRadius radius: CGFloat) {
		
		self.layer.cornerRadius = radius
	}
	
	func roundCornersForAspectFit(radius: CGFloat)
	{
		if let _ = (self as? UIImageView)?.image {
			
			//calculate drawingRect
			let drawingRect : CGRect = self.bounds
			
			let path = UIBezierPath(roundedRect: drawingRect, cornerRadius: radius)
			let mask = CAShapeLayer()
			mask.path = path.cgPath
			self.layer.mask = mask
		}
	}
	
	func setRoundedBorder(cornerRadius radius: CGFloat,
	                      borderWidth: CGFloat,
	                      borderColor: UIColor) {
		self.layer.cornerRadius = radius
		self.layer.borderWidth = 1.0
		self.layer.borderColor = borderColor.cgColor
	}
	
	func setBorderShadow(radius: CGFloat,
	                     color: UIColor) {
		
		self.layer.shadowOffset = CGSize.zero
		self.layer.shadowRadius = radius
		self.layer.shadowColor = color.cgColor
		self.layer.shadowOpacity = 1.0
		self.layer.shouldRasterize = true
	}
	
	func setCornerRadiusOnBottom(cornerRadius radius: CGFloat) {
		
		let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [UIRectCorner.bottomLeft, UIRectCorner.bottomRight], cornerRadii: CGSize(width: radius, height: radius))
		let maskLayer = CAShapeLayer()
		maskLayer.frame = self.bounds
		maskLayer.path = maskPath.cgPath
		self.layer.mask = maskLayer
	}
	
	func setCornerRadiusOnTop(cornerRadius radius: CGFloat) {
		
		let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [UIRectCorner.topLeft, UIRectCorner.topRight], cornerRadii: CGSize(width: radius, height: radius))
		let maskLayer = CAShapeLayer()
		maskLayer.frame = self.frame
		maskLayer.path = maskPath.cgPath
		self.layer.mask = maskLayer
	}
}

class CornerRoundedView: UIView {
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.setCornerRadius(cornerRadius: 3.0)
	}
}
