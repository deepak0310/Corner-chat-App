//
//  FBAPIEndpoints.swift
//  corner
//
//  Created by Marco Cabazal on 10/12/2016.
//  Copyright © 2016 Big Screen Entertainment. All rights reserved.
//

struct APIEndpoints {

	static let apiBase 								= "\(AppConfig.apiHost)/\(AppConfig.apiVersion)"

	static let signinWithFacebookAPI	= "\(apiBase)/signin_with_facebook"
	static let signinWithGoogleAPI		= "\(apiBase)/signin_with_google"
	static let signupAPI							= "\(apiBase)/signup"
	static let signinAPI							= "\(apiBase)/signin"
	static let refreshAuthTokensAPI 	= "\(apiBase)/refresh_tokens"

	static let profileAPI							= "\(apiBase)/profile"
	static let notificationsAPI 			= "\(apiBase)/notifications"
	static let notifyAPI							= "\(apiBase)/notify"

	static let shopProfileAPI					= "\(apiBase)/shop_profile"
	static let shopsAPI								= "\(apiBase)/shops"
}

extension APIEndpoints {

	static let fbBase 								= "https://graph.facebook.com/v2.8"

	static let userProfileAPI					= "\(fbBase)/me"
	static let appFriendsAPI					= "\(fbBase)/me/friends"
	static let friendsAPI							= "\(fbBase)/me/taggable_friends"
}
