//
//  LogInViewController.swift
//  Corner
//
//  Created by MobileGod on 27/01/2017.
//  Copyright © 2017 BSE. All rights reserved.
//

import UIKit

class LoadingIndicatorView {
	
	static var currentOverlay : UIView?
	
	static func show(indicatorPoint: CGPoint? = nil) {
		guard let currentMainWindow = UIApplication.shared.keyWindow else {
			print("No main window.")
			return
		}
		if indicatorPoint != nil {
			show(currentMainWindow, loadingText: nil, indicatorPoint: indicatorPoint!)
		} else {			
			show(currentMainWindow)
		}
	}
	
	static func show(_ loadingText: String) {
		guard let currentMainWindow = UIApplication.shared.keyWindow else {
			print("No main window.")
			return
		}
		show(currentMainWindow, loadingText: loadingText)
	}
	
	static func show(_ overlayTarget : UIView) {
		show(overlayTarget, loadingText: nil)
	}
	
	static func show(_ overlayTarget : UIView, loadingText: String?, indicatorPoint: CGPoint? = nil) {
		// Clear it first in case it was already shown
		hide()
		
		// Create the overlay
		let overlay = UIView(frame: overlayTarget.frame)
		overlay.center = overlayTarget.center
		overlay.alpha = 1
		overlay.backgroundColor = UIColor.clear
		overlayTarget.addSubview(overlay)
		overlayTarget.bringSubview(toFront: overlay)
		
		// Background ImageView
		let imageView = UIImageView(frame: overlay.frame)
		imageView.alpha = 0
		imageView.backgroundColor = UIColor.gray
		overlay.addSubview(imageView)
		
		// Create and animate the activity indicator
		let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
		
		indicator.color = UIColor.gray
		if indicatorPoint != nil {
			indicator.center = indicatorPoint!
		} else {
			
			indicator.center = overlay.center
		}
		indicator.startAnimating()
		overlay.addSubview(indicator)
		
		// Create label
		if let textString = loadingText {
			let label = UILabel()
			label.text = textString
			label.textColor = UIColor.black
			label.sizeToFit()
			label.center = CGPoint(x: indicator.center.x, y: indicator.center.y + 30)
			overlay.addSubview(label)
		}
		
		// Animate the overlay to show
		UIView.beginAnimations(nil, context: nil)
		UIView.setAnimationDuration(0.5)
//		overlay.alpha = overlay.alpha > 0 ? 0 : 0.5
		UIView.commitAnimations()
		
		currentOverlay = overlay
	}
	
	static func hide() {
		if currentOverlay != nil {
			currentOverlay?.removeFromSuperview()
			currentOverlay =  nil
		}
	}
}
