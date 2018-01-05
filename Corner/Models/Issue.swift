//
//  Issue.swift
//  Corner
//
//  Created by Marco Cabazal on 04/08/2017.
//  Copyright © 2017 BSE. All rights reserved.
//

import Foundation

import FirebaseDatabase

class Issue: CustomStringConvertible {

	var id = ""
	var ownerOID = ""
	var ownerFullName = ""
    var image1 = ""
    var image2 = ""
    var image3 = ""
	var open = true
	var image = ""
	var message = ""
	var conversations = [Conversation]()
    var createdAt = TimeInterval()
    var updatedAt = TimeInterval()

	typealias IssueResponse = ([Issue]?, Error?) -> Void

    init (id: String, ownerOID: String, ownerFullName: String, message: String, image1: String = "", image2: String = "", image3: String = "", open: Bool, createdAt: TimeInterval, updatedAt: TimeInterval) {

		self.id = id
		self.ownerOID = ownerOID
		self.ownerFullName = ownerFullName
		self.message = message
		self.open = open
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.image1 = image1
        self.image2 = image2
        self.image3 = image3
	}

	var description: String {
		return "\(message) id=\(id) owner=\(ownerFullName) open=\(open) createdAt=\(createdAt)"
	}

	static func loadIssues(user: User, completion: IssueResponse?) {

        guard user.oid != "" else { completion!(nil, nil); return }
        guard APIManager.keychain[Prefs.tokenKey] != nil else { completion!(nil, nil); return }
        guard IssuesManager.shared.firebaseReference != nil else { completion!(nil, nil); return }
        print("loading issues for user.oid \(user.oid)")
        IssuesManager.shared.firebaseReference.child("/users/\(user.oid)/issues/")
            .observeSingleEvent(of: .value, with: { (snapshot) in
//                print("LOADING \(IssuesManager.shared.firebaseReference!)/users/\(user.oid)/issues/")
                print("snapshot.value = \(snapshot.value)")
                if let issues = snapshot.value as? [String: AnyObject] {
//                    print(issues)
                    var issuesTemp = [Issue]()
                    
                    for (key, value) in issues {
                        var image1 = "", image2 = "", image3 = ""
                        if let images = value["images"] as? [String: Any] {
                            if let image1Value = images["image1"] as? String {
                                image1 = image1Value
                            }
                            if let image2Value = images["image2"] as? String {
                                image2 = image2Value
                            }
                            if let image3Value = images["image3"] as? String {
                                image3 = image3Value
                            }
                        }
                        var updated_at = TimeInterval()
                        if let unwrappedUpdatedAt = value["updated_at"] as? TimeInterval {
                            updated_at = unwrappedUpdatedAt
                        }
                        let issue = Issue(id: key,
                                          ownerOID: value["owner_oid"] as! String,
                                          ownerFullName: value["owner_name"] as! String,
                                          message: value["message"] as! String,
                                          image1: image1,
                                          image2: image2,
                                          image3: image3,
                                          open: value["open"] as! Bool,
                                          createdAt: value["created_at"] as! TimeInterval,
                                          updatedAt: updated_at
                                          )
                        if let conversations = value["conversations"] as? [String : Any] {
                                                        var conversationsTemp = [Conversation]()
                            for (key, value) in conversations {
                                let valueDict = value as! [String : Any]
                                let conversation = Conversation(id: valueDict["id"] as! String,
                                                                issueID: issue.id,
                                                                shopName: valueDict["shop_name"] as! String,
                                                                correspondentOID: key,
                                                                correspondentFullName: valueDict["employee_name"] as! String,
                                                                lastPosterOID: valueDict["last_poster_oid"] as! String,
                                                                lastPosterName: valueDict["last_poster_name"] as! String,
                                                                lastMessage: valueDict["last_message"] as! String,
                                                                updatedAt: Date().timeIntervalSince1970
                                                                )
                                conversationsTemp.append(conversation)
                            }
                            issue.conversations = conversationsTemp
                        }
                        issuesTemp.append(issue)
                    }
                    DataManager.shared.issues = issuesTemp
                    if let completion = completion {
                        completion(issuesTemp, nil)
                    }
                }
                
            }) { (error) in
                if let completion = completion {
                    completion(nil, error)
                }
        }
    }
    
    static func updateIssueUpdatedDate(issue: Issue) {
        IssuesManager.shared.firebaseReference.child("/users/\(issue.ownerOID)/issues/\(issue.id)/").updateChildValues(["updated_at":Date().timeIntervalSince1970])
    }
    
    static func create(message: String, shops: [Shop]?) -> String {
        
        var targetShops = [Shop]()
        
        if let shops = shops {
            targetShops = shops
        } else {
            targetShops = DataManager.shared.unblockedShops
        }
        
        // generate unique key for new issue
        let issueID = IssuesManager.shared.generateIssueID()
        guard let user = DataManager.shared.currentUser else { return "" }
        let initialMessageDictionary = [
            "owner_oid": user.oid,
            "owner_name": user.fullName,
            "message": message,
			"image": "imageURL",
			"created_at": Date().timeIntervalSince1970,
			"updated_at": Date().timeIntervalSince1970
			] as [String : Any]


		// add "open" attribute to initialMessageDictionary so it can also serve as issueDictionary
		var issueDictionary = initialMessageDictionary
		issueDictionary["open"] = true


		var userConversationsArray = [String : Any]()
		var globalConversationsArray = [String : Any]()
		var employeesArray = [String : Any]()

		for shop in targetShops {

			// create a new conversation with each employee/shop with a unique key
            
            print(Database.database().reference())
            
            let firebaseReference = Database.database().reference();
            
            let date = Date()
            let timestamp = CLong(date.timeIntervalSinceNow)
            let negatedTimestamp = -timestamp
            let bulkMessage = Message(timestamp: timestamp, negatedTimestamp: negatedTimestamp, dayTimestamp: 0, body: message, from: user.oid, shop: shop.oid, employee: shop.employee.oid, email: user.email)

            print("user id = %@, shop id = %@", user.oid, shop.oid)
        firebaseReference.child("notifications").child("messages").childByAutoId().setValue(bulkMessage.toAnyObject())
        firebaseReference.child("messages").child(user.oid).child(shop.oid).childByAutoId().setValue(bulkMessage.toAnyObject())
            
            if (user.oid != shop.oid) {
                firebaseReference.child("messages").child(shop.oid).child(user.oid).childByAutoId().setValue(bulkMessage.toAnyObject())
            }
            
            ///////////////////////////////
			let conversationID = firebaseReference.child("/issues/\(issueID)/conversations").childByAutoId().key

			let initialMessageID = IssuesManager.shared.generateMessageID(issueID: issueID, conversationID: conversationID)

			let conversationDictionary = [
				"id" : conversationID,
				"last_poster_oid" : user.oid,
				"last_poster_name" : user.fullName,
				"last_message" : message,
				"shop_name" : shop.name,
				"employee_name" : shop.employee.fullName
				] as [String : Any]
			userConversationsArray[shop.employee.oid] = conversationDictionary


			globalConversationsArray[conversationID] = [
				initialMessageID: initialMessageDictionary
			]

			var employeeDictionary = issueDictionary

            guard let user = DataManager.shared.currentUser else { return "" }
			employeeDictionary["conversations"] = [
				"\(user.oid)" : conversationDictionary
				] as [String : Any]

			employeesArray["/users/\(shop.employee.oid)/issues/\(issueID)"] = employeeDictionary

		}

		var userDictionary = issueDictionary
		userDictionary["conversations"] = userConversationsArray
		issueDictionary["conversations"] = globalConversationsArray

		var newIssue = [
			"/issues/\(issueID)" : issueDictionary,
			"/users/\(user.oid)/issues/\(issueID)" : userDictionary
			] as [String : Any]
        
        

		newIssue.merge(dict: employeesArray)
        
        var shopOids = [String: Bool]()
        for shop in targetShops {
            shopOids.updateValue(true, forKey: "/unread/\(shop.oid)/\(issueID)/")
            print("**marking /unread/\(shop.oid)/\(issueID) unread ***")
        }
        
        newIssue.merge(dict: shopOids)

        IssuesManager.shared.firebaseReference.updateChildValues(newIssue) { (error, databaseRef) in
            
            print(error)
            print(databaseRef)
        }
        
        return issueID
	}
    
	static func uploadImage(image: UIImage, messageID: String, issue: Issue, conversation: Conversation) {

		let localFile = URL(string: "path/to/image")!
		let imageLocation = "/issues/\(issue.id)/images/\(conversation.id)/\(messageID)/image.png"
		let imageRef = IssuesManager.shared.firebaseStorage.child(imageLocation)

		let uploadTask = imageRef.putFile(from: localFile, metadata: nil) { metadata, error in

			if let metadata = metadata {
				let imageURL = metadata.downloadURL()
				print("firebase: got url \(imageURL!.absoluteString)")
			} else {
				print("firebase: error in image upload: \(error!.localizedDescription)")
			}
		}

		uploadTask.resume()
	}
}
