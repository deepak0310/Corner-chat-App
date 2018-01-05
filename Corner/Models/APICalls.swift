//
//  APICalls.swift
//  Corner
//
//  Created by MobileGod on 10/02/2017.
//  Copyright © 2017 BSE. All rights reserved.
//

import Alamofire
import SwiftyJSON

final class APICalls {
	
	fileprivate let baseURL = "http://ec2-52-62-3-227.ap-southeast-2.compute.amazonaws.com/index.php/api/"
	static var sharedInstance = APICalls()
	
	// MARK: /*---------------------------- Register/Login -----------------------------*/
	
	public func registerUser(type:			String,
	                         name:			String,
	                         email:			String,
	                         userPic_url:	String,
	                         address1:		String,
	                         address2:		String,
	                         phonenumber:	String,
	                         password:		String,
	                         completion: @escaping (_ response: AnyObject?, _ error: NSError?) -> Void) {
		
		let parameter: [String: AnyObject] = [
			"type":			type as AnyObject,
			"name":			name as AnyObject,
			"email":		email as AnyObject,
			"image_url":	userPic_url as AnyObject,
			"address1":		address1 as AnyObject,
			"address2":		address2 as AnyObject,
			"phone_number":	phonenumber as AnyObject,
			"password":		password.MD5 as AnyObject
		]
		
		Alamofire.request(baseURL + "register", method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
			
			switch response.result {
			case .success:
				print("User Register API Result: \(response.result)")
				completion(response.result.value as AnyObject?, nil)
			case .failure(let error):
				print("User Register API error: \(error)")
				completion(nil, error as NSError?)
			}
		}
	}
	
	public func loginUser(name: String, password: String) {

	}
}
