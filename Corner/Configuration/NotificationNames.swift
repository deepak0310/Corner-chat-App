//
//  NotificationNames.swift
//  Corner
//
//  Created by Marco Cabazal on 10/12/2016.
//  Copyright © 2016 Big Screen Entertainment. All rights reserved.
//
import UIKit

extension Notification.Name {

	static let appDidBecomeActive   		= Notification.Name(rawValue: "appDidBecomeActive")

	static let gotShops 								= Notification.Name(rawValue: "gotShops")
	static let gotIssues 								= Notification.Name(rawValue: "gotIssues")

	static let gotConversations 				= Notification.Name(rawValue: "gotConversations")
	static let gotConversation 					= Notification.Name(rawValue: "gotConversation")

	static let dataSourceReady      		= Notification.Name(rawValue: "dataSourceReady")
	static let dataSourceFailure    		= Notification.Name(rawValue: "dataSourceFailure")

	static let authenticated        		= Notification.Name(rawValue: "authenticated")
	static let userLogout           		= Notification.Name(rawValue: "userLogout")

	static let unreadCountsChanged						= NSNotification.Name(rawValue: "unreadCountsChanged")
	static let gotIncomingMessageInChat	= Notification.Name(rawValue: "gotIncomingMessageInChat")
	static let conversationsChanged			= Notification.Name(rawValue: "conversationsChanged")
}
