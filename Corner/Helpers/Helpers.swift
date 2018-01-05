//
//  MiscHelpers.swift
//  HappyWaves
//
//  Created by Marco Cabazal on 10/12/2016.
//  Copyright © 2016 Big Screen Entertainment. All rights reserved.
//

import UIKit
import UserNotifications

struct Helpers {

	static func scheduleLocalNotification(_ body: String, alertAction: String, fireDate: Date) {
		// TODOx: implement iOS 10 local notifications
	}

	static func isIPhone6Plus()-> Bool{

		var retVal = false
		if UI_USER_INTERFACE_IDIOM() == .phone {

			let screen = UIScreen.main
			if screen.scale > 2.9 || screen.bounds.size.height > 720 {
				retVal = true
			}
		}
		return retVal
	}

	static func isIPhone5AndBelow()-> Bool{

		var retVal = false
		if UI_USER_INTERFACE_IDIOM() == .phone {

			let screen = UIScreen.main
			if screen.bounds.size.height <= 568 {
				retVal = true
			}
		}
		return retVal
	}

	static func currentAppBadge() -> Int {

		let currentAppBadge = UIApplication.shared.applicationIconBadgeNumber
		return currentAppBadge
	}

	static func unreadDiscussionsCount() -> Int {

		let unread = UserDefaults.standard.integer(forKey: Prefs.unreadDiscussionsCount)
		return unread
	}

	static func unreadConversationsCount() -> Int {

		let unread = UserDefaults.standard.integer(forKey: Prefs.unreadConversationsCount)
		return unread
	}

	static func initializeAppBadge() {

		let newBadge = Helpers.unreadDiscussionsCount() + Helpers.unreadConversationsCount()
		UIApplication.shared.applicationIconBadgeNumber = newBadge
	}

	static func adjustUnreadCounts() {
//		print("UNREAD: adjusting unread counts")
		Helpers.initializeAppBadge()
		NotificationCenter.default.post(name: .unreadCountsChanged, object: nil)
	}
}

extension Date {

	static func currentDateTimeString() -> String {
		let formatter = DateFormatter()
		formatter.dateFormat="MM-dd-yyyy"
		return formatter.string(from: Date())
	}
}

extension UIColor {

	convenience init(red: Int, green: Int, blue: Int, withAlpha: Float) {
		assert(red >= 0 && red <= 255, "Invalid red component")
		assert(green >= 0 && green <= 255, "Invalid green component")
		assert(blue >= 0 && blue <= 255, "Invalid blue component")

		self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(withAlpha))
	}

	convenience init(hex:Int, alpha: Float) {
		self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff, withAlpha:alpha)
	}
}

extension Dictionary {

	mutating func merge(dict: [Key: Value]){
		for (key, value) in dict {
			updateValue(value, forKey: key)
		}
	}
}
