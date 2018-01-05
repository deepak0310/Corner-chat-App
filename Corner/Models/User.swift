//
//  User.swift
//  Corner
//
//  Created by Marco Cabazal on 11/19/2016.
//  Copyright © 2016 Big Screen Entertainment. All rights reserved.
//

import Foundation
import UserNotifications
import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import SwiftyJSON
import GoogleSignIn
import FacebookLogin

class User: Mappable {

	var oid               = ""
	var fbID              = ""
	var fbProfilePhoto		= ""
  var googleProfilePhoto = ""
	var gender						= ""
	var email             = ""
	var avatar            = ""
	var firstName         = ""
	var lastName          = ""
	var fullName          = ""
	var token             = ""
	var firebaseToken     = ""
	var role             	= ""
	var shop:	Shop?
	var location          = "Sydney, NSW"
	var tempPassword      = ""
	var notificationsEnabled = true
	var createdAt: Date?
	var updatedAt: Date?
	var validated:Bool = false

	static let keyPath = "user"

	typealias UserResponse = (User?, Error?, JSON?) -> Void

	func mapping(map: Map) {
		oid <- map["oid"]
		fbID <- map["fb_id"]
		fbProfilePhoto <- map["fb_profile_photo"]
    googleProfilePhoto <- map["google_profile_photo"]
		gender <- map["gender"]
		createdAt <- (map["created_at"], RailsDateTransform())
		updatedAt <- (map["updated_at"], RailsDateTransform())
		email <- map["email"]
		avatar <- map["avatar"]
		firstName <- map["first_name"]
		lastName <- map["last_name"]
		fullName <- map["full_name"]
		token <- map["token"]
		firebaseToken <- map["firebase_token"]
		role <- map["role"]
		shop <- map["shop"]
		location <- map["location"]
		notificationsEnabled <- map["notifications_enabled"]
		tempPassword <- map["temp_password"]
		validated <- map["validated"]
	}

	required convenience init?(map: Map) {
		self.init()
	}

	static func getFacebookProfile(_ completion: @escaping (JSON?) -> Void) {

		Alamofire.request(Router.getFacebookProfile)
			.validate()
			.responseJSON { response in

				guard let data = response.data else { return }
				let json = JSON(data: data)

				completion(json)
		}
	}

	static func signInWithFacebook(email: String, facebookID: String, facebookToken: String,
	                               facebookProfilePhoto: String, firstName: String, lastName: String,
	                               gender: String, completion: @escaping UserResponse) {

		APIManager.shared.request(object: User.self, router: Router.signinWithFacebook(email: email, facebookID: facebookID, facebookToken: facebookToken, facebookProfilePhoto: facebookProfilePhoto, firstName: firstName, lastName: lastName, gender: gender), keyPath: "user") { (user, error, json) in

			if let user = user {
        
        APIManager.keychain[Prefs.avatarKey] = facebookProfilePhoto //directly assign the profile logo since server does not return yet
				user.saveCredentialsToKeychain()
				if user.notificationsEnabled {
					user.registerForNotifications()
				} else {
					user.unRegisterForRemoteNotifications()
				}

				completion(user, nil, json)
			} else {
				completion(nil, error, json)
			}
		}
	}

	static func signInWithGoogle(email: String, googleID: String,
	                             googleProfilePhoto: String, firstName: String, lastName: String, completion: @escaping UserResponse) {


		APIManager.shared.request(object: User.self, router: Router.signinWithGoogle(email: email, googleID: googleID, googleProfilePhoto: googleProfilePhoto, firstName: firstName, lastName: lastName), keyPath: "user") { (user, error, json) in
      
      APIManager.keychain[Prefs.avatarKey] = googleProfilePhoto
			if let user = user {
				user.saveCredentialsToKeychain()
				if user.notificationsEnabled {
					user.registerForNotifications()
				} else {
					user.unRegisterForRemoteNotifications()
				}

				completion(user, nil, json)
			} else {
				completion(nil, error, json)
			}
		}
	}
  
	static func signup(email: String, password: String, firstName: String, lastName: String, _ completion: @escaping UserResponse) {

    APIManager.shared.request(object: User.self, router: Router.signup(email: email, password: password, firstName: firstName, lastName: lastName), keyPath: "user") { (user, error, json) in

			if let user = user {
				user.saveCredentialsToKeychain()
				if user.notificationsEnabled {
					user.registerForNotifications()
				} else {
					user.unRegisterForRemoteNotifications()
				}

				completion(user, nil, json)
			} else {
				completion(nil, error, json)
			}
    }
  }
  
  static func signin(email: String, password: String, _ completion: @escaping UserResponse) {
    
    APIManager.shared.request(object: User.self, router: Router.signin(email: email, password: password), keyPath: "user") { (user, error, json) in
      
      if let user = user {
        user.saveCredentialsToKeychain()
        if user.notificationsEnabled {
          user.registerForNotifications()
        } else {
          user.unRegisterForRemoteNotifications()
        }
        
        completion(user, nil, json)
      } else {
        completion(nil, error, json)
      }
    }
  }

	static func refreshAuthTokens(_ completion: @escaping UserResponse) {

		APIManager.shared.request(object: User.self, router: Router.refreshTokens, keyPath: "user", completion: completion)
	}

	func saveCredentialsToKeychain() {

		APIManager.keychain[Prefs.tokenKey]     	= self.token
		APIManager.keychain[Prefs.firebaseTokenKey] = self.firebaseToken
		APIManager.keychain[Prefs.timeTokenRefresh] = Date.currentDateTimeString()
		APIManager.keychain[Prefs.userOIDKey]   	= self.oid
		if self.avatar.characters.count > 0 {
			APIManager.keychain[Prefs.avatarKey] = self.avatar
		} else if self.fbProfilePhoto.characters.count > 0 {
			APIManager.keychain[Prefs.avatarKey] = self.fbProfilePhoto
    } else if self.googleProfilePhoto.characters.count > 0 {
      APIManager.keychain[Prefs.avatarKey] = self.googleProfilePhoto
    }
		APIManager.keychain[Prefs.firstNameKey] 	= self.firstName
		APIManager.keychain[Prefs.lastNameKey]  	= self.lastName
		APIManager.keychain[Prefs.fullNameKey]  	= self.fullName
		APIManager.keychain[Prefs.emailKey]     	= self.email
		APIManager.keychain[Prefs.roleKey]     	= self.role

		APIManager.keychain[Prefs.notificationEnabled] = self.notificationsEnabled ? "true" : "false"

		DataManager.shared.currentUser = self

		NotificationCenter.default.post(name: .authenticated, object: nil)
	}

	func registerForNotifications() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.registerForNotifications()
	}

	func sendDeviceToken(apns: String, completion: @escaping UserResponse) {
		APIManager.shared.request(object: User.self, router: Router.sendDeviceToken(apns: apns), keyPath: "user", completion: completion)
	}

	func disableNotifications(completion: @escaping UserResponse) {
		APIManager.shared.request(object: User.self, router: Router.disableNotifications, keyPath: "user", completion: completion)
	}

	func unRegisterForRemoteNotifications() {

		if UIApplication.shared.isRegisteredForRemoteNotifications {

			UIApplication.shared.unregisterForRemoteNotifications()
			APIManager.keychain[Prefs.notificationEnabled] = "false"
		}
	}

	func notifyUser(destination: User, message: String) {

		Alamofire.request(Router.notifyUser(source: self, destination: destination, message: message))
			.validate()
			.responseJSON(completionHandler: { response in

				if response.result.isFailure {
					print("API Error in notifyUSer: \(response.response!.statusCode)")
				}
			})
	}

	static func forceLogout() {

    //Cancel all live Alamo request
    let sessionManager = Alamofire.SessionManager.default
    sessionManager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
      
      dataTasks.forEach { $0.cancel() }
      uploadTasks.forEach { $0.cancel() }
      downloadTasks.forEach { $0.cancel() }
      
    }
    
		do {
			try APIManager.keychain.removeAll()
			UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
			UserDefaults.standard.synchronize()
		} catch let error {
			print("Error in forced logout \(error)")
		}

    GIDSignIn.sharedInstance().signOut()
    LoginManager().logOut()
    
	}
}
