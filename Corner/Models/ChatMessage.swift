//
//  ChatMessage.swift
//  Corner
//
//  Created by Marco Cabazal on 04/08/2017.
//  Copyright © 2017 BSE. All rights reserved.
//

import Foundation
import Firebase

class ChatMessage {

	var ownerOID = ""
	var ownerFullname = ""
	var message = ""
	var image = ""
	var created_at = TimeInterval()


    static func send(message: String, issue: Issue, conversation: Conversation) {
        guard let user = DataManager.shared.currentUser else { return }
        let correspondent = conversation.correspondentOID
        var ownOID = user.oid
        let ownFullName = user.fullName
        
        let messageDictionary = [
            "owner_oid": ownOID,
            "owner_name" : ownFullName,
            "message": message,
            "image" : "",
            "created_at": Date().timeIntervalSince1970
            ] as [String : Any]
        
        let newMessageID = IssuesManager.shared.generateMessageID(issueID: issue.id, conversationID: conversation.id)
        
        let newMessageUpdate = [
            "/issues/\(issue.id)/conversations/\(conversation.id)/updated_at"                       : Date().timeIntervalSince1970,
            "/issues/\(issue.id)/conversations/\(conversation.id)/\(newMessageID)"                  : messageDictionary,
            
            "/users/\(ownOID)/issues/\(issue.id)/conversations/\(correspondent)/last_message" 		: message,
            "/users/\(ownOID)/issues/\(issue.id)/conversations/\(correspondent)/last_poster_oid" 	: ownOID,
            "/users/\(ownOID)/issues/\(issue.id)/conversations/\(correspondent)/last_poster_name"   : ownFullName,
            
            "/users/\(correspondent)/issues/\(issue.id)/conversations/\(ownOID)/last_message" 		: message,
            "/users/\(correspondent)/issues/\(issue.id)/conversations/\(ownOID)/last_poster_oid" 	: ownOID,
            "/users/\(correspondent)/issues/\(issue.id)/conversations/\(ownOID)/last_poster_name"   : ownFullName,
            
            "/unread/\(correspondent)/\(issue.id)/\(conversation.id)"                               : true
            ] as [String : Any]
        
        print ("new message \(newMessageUpdate)")
        
        
        let firebaseReference = Database.database().reference();
        
        let date = Date()
        let timestamp = CLong(date.timeIntervalSinceNow)
        let negatedTimestamp = -timestamp
        let senderOID = ownOID
        let recipientOID = conversation.correspondentOID
        let bulkMessage = ReturnMessage(timestamp: timestamp, negatedTimestamp: negatedTimestamp, dayTimestamp: 0, body: message, to: conversation.correspondentOID, name: conversation.correspondentFullName)
        
        firebaseReference.child("notifications").child("returnmessages").childByAutoId().setValue(bulkMessage.toAnyObject())
        firebaseReference.child("returnmessages").child(senderOID).child(recipientOID).childByAutoId().setValue(bulkMessage.toAnyObject())
        if (senderOID != recipientOID) {
            firebaseReference.child("returnmessages").child(recipientOID).child(senderOID).childByAutoId().setValue(bulkMessage.toAnyObject())
        }
        
        
        IssuesManager.shared.firebaseReference.updateChildValues(newMessageUpdate, withCompletionBlock: { (error: Error?, ref: DatabaseReference!) in
            if error != nil {
                print("error = \(String(describing: error?.localizedDescription))")
            }

        })
    
        // Send a push notification to the user or shop
//        if let oid = user.shop?.oid, oid != "" {
//            ownOID = oid
//        }
        IssuesManager.shared.getUserToken(oid: conversation.correspondentOID) { (result) -> Void in
            if result != "" {
                let message = ["message": "Hello world!"]
                Messaging.messaging().sendMessage(message, to: "\(result)@gcm.googleapis.com", withMessageID: "", timeToLive: 1)
                print("Message sent to \(result)@gcm.googleapis.com")
            }
        }

        
        //		DataManager.shared.user.notifyUser(destination: otherUser, message: "\(ownFullName): \(message)")
    }

    //	static func uploadImage(issue: Issue, conversation: Conversation, messageID: String) {
    static func uploadImage(message:String, imagePath: String, issue: Issue, conversation: Conversation) {
        
        let messageID = IssuesManager.shared.generateMessageID(issueID: issue.id, conversationID: conversation.id)
        let localFile = URL(string: imagePath)!
        let imageLocation = "/issues/\(issue.id)/conversations/\(conversation.id)/\(messageID)/image.png"
        let imageRef = IssuesManager.shared.firebaseStorage.child(imageLocation)
        
        let uploadTask = imageRef.putFile(from: localFile, metadata: nil) { metadata, error in
            
            if let metadata = metadata {
                let imageURL = metadata.downloadURL()
                ChatMessage.sendImage(message:message, issue: issue, conversation: conversation, imageUrl: imageURL!.absoluteString, messageId: messageID)
                print("firebase: got url \(imageURL!.absoluteString)")
            } else {
                print("firebase: error in image upload: \(error!.localizedDescription)")
            }
        }
        
        uploadTask.resume()
    }
    
  static func sendImage(message: String, issue: Issue, conversation: Conversation, imageUrl:String, messageId:String) {
    guard let user = DataManager.shared.currentUser else { return }
    let correspondent = conversation.correspondentOID
    let ownOID = user.oid
    let ownFullName = user.fullName
    
    let messageDictionary = [
      "owner_oid": ownOID,
      "owner_name" : ownFullName,
      "message": "",
      "image" : imageUrl,
      "created_at": Date().timeIntervalSince1970
      ] as [String : Any]
    
    let newMessageUpdate = [
      "/issues/\(issue.id)/conversations/\(conversation.id)/\(messageId)" 					: messageDictionary,
      
      "/users/\(ownOID)/issues/\(issue.id)/conversations/\(correspondent)/last_message" 	: message,
      "/users/\(ownOID)/issues/\(issue.id)/conversations/\(correspondent)/last_poster_oid" 	: ownOID,
      "/users/\(ownOID)/issues/\(issue.id)/conversations/\(correspondent)/last_poster_name" : ownFullName,
      
      "/users/\(correspondent)/issues/\(issue.id)/conversations/\(ownOID)/last_message" 	: message,
      "/users/\(correspondent)/issues/\(issue.id)/conversations/\(ownOID)/last_poster_oid" 	: ownOID,
      "/users/\(correspondent)/issues/\(issue.id)/conversations/\(ownOID)/last_poster_name" : ownFullName,
      
      "/unread/\(correspondent)/\(issue.id)/\(conversation.id)" 							: true
      ] as [String : Any]
    
    print("new message \(newMessageUpdate)")
    
    IssuesManager.shared.firebaseReference.updateChildValues(newMessageUpdate)
    
    //		DataManager.shared.user.notifyUser(destination: otherUser, message: "\(ownFullName): \(message)")
  }

}
