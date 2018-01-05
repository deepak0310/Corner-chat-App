//
//  PreferenceKeys.swift
//  Corner
//
//  Created by Marco Cabazal on 10/12/2016.
//  Copyright © 2016 Big Screen Entertainment. All rights reserved.
//

struct Prefs {

	// Note the use of apiHost as suffix. This is so that one can test against multiple api environments (dev, staging, production)
	// NSUserDefaults
	static let userKey								= "user-\(AppConfig.apiHost)-"

	// Keychain Keys
	static let tokenKey 							= "jwt-\(AppConfig.apiHost)"
	static let firebaseTokenKey 			= "firebase-\(AppConfig.apiHost)"
	static let userOIDKey 						= "oid-\(AppConfig.apiHost)"
	static let roleKey 								= "role-\(AppConfig.apiHost)"
	static let avatarKey 							= "avatar-\(AppConfig.apiHost)"
	static let firstNameKey 					= "firstName-\(AppConfig.apiHost)"
	static let lastNameKey 						= "lastName-\(AppConfig.apiHost)"
	static let fullNameKey 						= "fullName-\(AppConfig.apiHost)"
	static let emailKey 							= "email-\(AppConfig.apiHost)"
	static let timeTokenRefresh 		  = "time-\(AppConfig.apiHost)"
	static let gender 								= "gender-\(AppConfig.apiHost)"
	static let notificationEnabled    = "notificationEnabled-\(AppConfig.apiHost)"

	static let lastUnreadCheckKey					= "lastUnreadCheck-\(AppConfig.apiHost)"

	static let unreadDiscussionsCount			= "unreadDiscussionsCount-\(AppConfig.apiHost)"
	static let unreadDiscussions					= "unreadDiscussions-\(AppConfig.apiHost)"
	static let unreadDiscussion						= "unreadDiscussion-\(AppConfig.apiHost)"

	static let unreadConversationsCount		= "unreadConversationsCount-\(AppConfig.apiHost)"
	static let unreadConversations				= "unreadConversations-\(AppConfig.apiHost)"
	static let unreadConversation					= "unreadConversation-\(AppConfig.apiHost)"

	static let shouldForceLogoutKey		= "shouldForceLogout"
	static let firstLaunch						= "firstLaunch"
}
