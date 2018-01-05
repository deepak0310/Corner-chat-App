//
//  Utility.swift
//  Corner
//
//  Created by MobileGod on 25/01/2017.
//  Copyright © 2017 BSE. All rights reserved.
//

import Foundation
import UIKit
import Dispatch


class Utility {
	
	static func DurationToText(duration: Int) -> String {
		
		let hour: Int = duration / 3600
		let min: Int = (duration % 3600) / 60
		let sec: Int = duration % 60
		
		if hour > 0 {
			return String(format: "%d:%02d:%02d", hour, min, sec)
		} else {
			return String(format: "%02d:%02d", min, sec)
		}
	}
}

extension UIViewController {
	
	public func showAlertWithTitle(_ title: String!, message: String, toFocus:UITextField) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel,handler: {_ in
			toFocus.becomeFirstResponder()
		});
		alert.addAction(action)
		present(alert, animated: true, completion:nil)
	}
	
	public func showAlertWithSelection(_ title: String, message: String?, ok: @escaping () -> Void, cancel: @escaping () -> Void){
		
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "OK", style: .default) {
			(action: UIAlertAction) -> Void in
			ok()
		}
		let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel) { (action) in
			cancel()
		}
		alert.addAction(okAction)
		alert.addAction(cancelAction)
		present(alert, animated: true, completion: nil)
	}
	
	public func showAlert(_ title: String, message: String, ok: (() -> Void)? = nil) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "OK", style: .default) {
			(action: UIAlertAction) -> Void in
			ok?()
		}
		alert.addAction(okAction)
		present(alert, animated: true, completion: nil)
	}
	
	public func showAlertSheet(_ title: String, message: String, yes: String, no: String, yesClicked: @escaping () -> Void) {
	
		let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
		let yesAction = UIAlertAction(title: yes, style: .default) {
			(action: UIAlertAction) -> Void in
			yesClicked()
		}
		let noAction = UIAlertAction(title: no, style: .default) { (action) in
			
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
			
		}
		alert.addAction(yesAction)
		alert.addAction(noAction)
		alert.addAction(cancelAction)
		present(alert, animated: true, completion: nil)
	}
}

extension UITextField {
	
	internal func SetPlaceHolderWithTextColor(text: String, color: UIColor) {
		
		let attributePlaceholderColor = [NSForegroundColorAttributeName: color]
		self.attributedPlaceholder = NSAttributedString(string: text,
		                                                attributes: attributePlaceholderColor)
	}
}

private let whitespaces = CharacterSet.whitespacesAndNewlines

public extension String {
	
	/// Removes whitespaces from both ends of the string.
	public func trimWhitespaces() -> String {
		return self.trimmingCharacters(in: whitespaces)
	}
	
	/// A new string made by deleting the extension
	/// (if any, and only the last) from the receiver.
	public var stringByDeletingPathExtension: String {
		let string: NSString = self as NSString
		return string.deletingPathExtension
	}
	
	/// The last path component.
	/// This property contains the last path component. For example:
	///
	/// 	 /tmp/scratch.tiff ➞ scratch.tiff
	/// 	 /tmp/scratch ➞ scratch
	/// 	 /tmp/ ➞ tmp
	///
	public var lastPathComponent: String {
		let string: NSString = self as NSString
		return string.lastPathComponent
	}
	
	// MARK: - Validating User Properties
	//
	
	/// Is the *name* format valid?
	public func isValidName() -> Bool {
//		let RegEx = "\\A\\w{7,18}\\z"
//		let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
//		return Test.evaluate(with: self)
		
		do
		{
			let regex = try NSRegularExpression(pattern: "^[0-9a-zA-Z\\_]{7,18}$", options: .caseInsensitive)
			if regex.matches(in: self, options: [], range: NSMakeRange(0, self.characters.count)).count > 0 {return true}
		}
		catch {}
		return false
	}
	
	/// Is the *email* format valid?
	public func isValidEmail() -> Bool {
		let emailRegex = regex("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
		return emailRegex.matchesString(self)
	}
	
	/// Is the *phone number* format valid?
	func isValidPhoneNumber() -> Bool {
		let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
		let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
		let result =  phoneTest.evaluate(with: self)
		return result
	}
	
	/// Is the *password* format valid?
	public func isValidPassword() -> Bool {
		return self.characters.count >= 8
	}
}

// MARK: - Regular Expressions

/// *Regex* creation syntax sugar (with no error handling).
///
/// For a quick guide, see:
/// * [NSRegularExpression Cheat Sheet and Quick Reference](http://goo.gl/5QzdhX)
public func regex(_ pattern: String, options: NSRegularExpression.Options = [ ])
	-> NSRegularExpression {
		let regex = try! NSRegularExpression(pattern: pattern, options: options)
		return regex
}

/// Useful extensions for NSRegularExpression objects.
public extension NSRegularExpression {
	
	/// Returns `true` if the specified string is fully matched by this regex.
	public func matchesString(_ string: String) -> Bool {
		// Ranges are based on the UTF-16 *encoding*.
		let length = string.utf16.count
		precondition(length == (string as NSString).length)
		
		let wholeString = NSRange(location: 0, length: length)
		let matches = numberOfMatches(in: string, options: [ ], range: wholeString)
		return matches == 1
	}
}

extension DispatchQueue {
	
	func after(_ delay: TimeInterval, execute closure: @escaping () -> Void) {
		
		asyncAfter(deadline: .now() + delay, execute: closure)
	}
}
