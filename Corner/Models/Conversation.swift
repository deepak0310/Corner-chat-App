//
//  Conversation.swift
//  Corner
//
//  Created by Marco Cabazal on 04/08/2017.
//  Copyright © 2017 BSE. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class Conversation: CustomStringConvertible {

	var id = ""
	var issueID = ""
	var correspondentOID = ""
	var correspondentFullName = ""
	var lastPosterName = ""
	var lastPosterOID = ""
	var lastMessage = ""
	var shopName = ""
    var updatedAt = TimeInterval()
	var messages = [ChatMessage]()

	init (id: String, issueID: String, shopName: String, correspondentOID: String, correspondentFullName: String, lastPosterOID: String, lastPosterName: String, lastMessage: String, updatedAt: TimeInterval) {
		
		self.lastPosterName = lastPosterName
		self.lastPosterOID = lastPosterOID
		self.lastMessage = lastMessage
		self.shopName = shopName
		self.correspondentOID = correspondentOID
		self.correspondentFullName = correspondentFullName
        self.updatedAt = updatedAt
		self.id = id
		self.issueID = issueID
	}

	var description: String {
		return "shop=\(shopName) message=\(lastMessage) correspondent=\(correspondentFullName) id=\(id)"
	}


	func markConversationAsRead() {
        guard let user = DataManager.shared.currentUser else { return }
		let keyPath = "/unread/\(user.oid)/\(issueID)/"
		debugPrint("removing \(keyPath)")
        IssuesManager.shared.firebaseReference.child(keyPath).removeValue(completionBlock: {(error, ref) in
                NotificationCenter.default.post(name: .updateIssues, object: nil)
            })

		Helpers.adjustUnreadCounts()
	}

	static func load(conversation: Conversation) {


	}

	func close() {
		// TODO: flag conversation in user as closed
		// TODO: flag conversation in other user as closed
	}
}
