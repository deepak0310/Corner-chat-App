//
//  Conversations.swift
//  Corner
//
//  Created by Marco Cabazal on 3/28/2016.
//  Copyright © 2016 Big Screen Entertainment. All rights reserved.
//

import Firebase
import FirebaseDatabase

class IssuesManager {

	fileprivate var conversationsSet = Set<String>()

	static let shared = IssuesManager()

	var firebaseReference: DatabaseReference!
	var firebaseStorage: StorageReference!

	func conversations() -> [String] {
		return Array(conversationsSet)
	}

	private init() {

//        if (Auth.auth().currentUser) != nil {
        
			print("conversations initialized")

			self.firebaseReference = Database.database().reference(fromURL: AppConfig.firebaseURL)
			self.firebaseStorage = Storage.storage().reference()

			Shop.fetchAll()

//        } else {
//            print("Chat: User is not authenticated")
//            User.forceLogout()
//        }
	}

	func generateMessageID(issueID: String, conversationID: String) -> String {

		let messageID = self.firebaseReference.child("/issues/\(issueID)/conversations/\(conversationID)").childByAutoId().key
		return messageID
	}


	func generateIssueID() -> String {

		let issueID = self.firebaseReference.child("/issues").childByAutoId().key
		return issueID
	}

	func getConversationID(otherUserOID: String, completion: @escaping (String?, Error?) -> Void) {

		self.firebaseReference.child("/users/\(APIManager.keychain[Prefs.userOIDKey]!)/conversations/\(otherUserOID)")
			.observeSingleEvent(of: .value, with: { (snapshot) in

				if let conversationID = snapshot.value! as? String {

					completion(conversationID, nil)

				} else {

					let conversationID = IssuesManager.shared.firebaseReference.child("conversations").childByAutoId().key
					completion(conversationID, nil)
				}

			}) { (error) in
                completion(nil, error)
        }
    }
    
    func getUserToken(oid: String, completion: @escaping (_ result: String) -> Void) {
        let ref = "/users/\(oid)/"
        self.firebaseReference.child(ref).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let userToken = value?["token"] as? String ?? ""
            completion(userToken)
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
            completion("")
        }
    }
    
    func writeUserOidToDatabase() {
        guard self.firebaseReference != nil else { return }
        guard let user = DataManager.shared.currentUser else { return }
        let uid = user.oid
        let today = Date().timeIntervalSince1970
        let dict = ["last_login": today]
        self.firebaseReference.child("/login/\(uid)/").updateChildValues(dict)
    }
    
    func listenForMessages(uid: String) {
        guard let user = DataManager.shared.currentUser else { return }
        let uid = user.oid
        print("observing /unread/\(uid)/")
        self.firebaseReference.child("/unread/\(uid)/").observe(.childAdded, with: { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            print("********\n\n\(postDict)\n\n*******")
            Issue.loadIssues(user: user) { (issues, error) in
                NotificationCenter.default.post(name: .updateIssues, object: nil)
            }
        })
        if let shopOid = user.shop?.oid {
            self.firebaseReference.child("/unread/\(shopOid)/").observe(.childAdded, with: { (snapshot) in
                Issue.loadIssues(user: user) {(issues, error) in
                    NotificationCenter.default.post(name: .updateIssues, object: nil)
                }
            })
        }
    }
    
    func fetchIssueImages(issue: Issue, uid: String, completion: @escaping (_ results: [String: String]) -> Void) {
        let ref = "/issues/\(issue.id)/images/"
        self.firebaseReference.child(ref).observeSingleEvent(of: .value, with: { (snapshot) in
            if let images = snapshot.value as? [String: String] {
                completion(images)
            } else {
                completion([:])
            }
            
        })
        { (error) in
            print("error \(error.localizedDescription)")
            completion([:])
        }
    }

    func getUnreadIssuesFromFirebase(completion: ((UIBackgroundFetchResult, [String]) -> Void)?) {
        
        guard let user = DataManager.shared.currentUser else { return }
        
        self.firebaseReference.child("/unread/\(user.oid)").observeSingleEvent(of: .value, with: { (snapshot) in
            
            var messages = [String]()
            
            if let conversations = snapshot.value as? [String: [String: Bool]] {
                for (otherOID, _) in conversations {
                    messages.append(otherOID)
                }
                
                print("API got unread", messages)
                UserDefaults.standard.set(messages, forKey: Prefs.unreadConversations)
                UserDefaults.standard.synchronize()
                Helpers.adjustUnreadCounts()
                
                if let completion = completion {
                    completion(.newData, messages)
                }
            } else {
                
                if let completion = completion {
                    completion(.noData, [""])
                }
            }
        })
        { (error) in
            print("error \(error.localizedDescription)")
            
            if let completion = completion {
                completion(.noData, [""])
            }
        }
        
    }
    
    func getUnreadConversationsFromFirebase(completion: ((UIBackgroundFetchResult, [String]) -> Void)?) {
        
        guard let user = DataManager.shared.currentUser else { return }
        
        self.firebaseReference.child("/unread/\(user.oid)").observeSingleEvent(of: .value, with: { (snapshot) in
            
            var messages = [String]()
            
            if let conversations = snapshot.value as? [String: [String: Bool]] {
                for (_, value) in conversations {
                    let unreadConversations = value
                    for convo in unreadConversations {
                        let conversationId = convo.0
                        let unread = convo.1
                        if unread { messages.append(conversationId) }
                    }
                    
                }
                
                print("API got unread", messages)
                
                if let completion = completion {
                    completion(.newData, messages)
                }
            } else {
                
                if let completion = completion {
                    completion(.noData, [""])
                }
            }
        })
        { (error) in
            print("error \(error.localizedDescription)")
            
            if let completion = completion {
                completion(.noData, [""])
            }
        }
    }
    
    func markIssueRead(issue: Issue) {
        guard let user = DataManager.shared.currentUser else { return }
        let unreadPath = "/unread/\(user.oid)/\(issue.id)"
        print("attempting to remove \(unreadPath)")
        self.firebaseReference.child(unreadPath).removeValue()
        
        guard let staffUserOid = user.shop?.oid else { return }
        let unreadPathStaff = "/unread/\(staffUserOid)/\(issue.id)/"
        self.firebaseReference.child(unreadPathStaff).removeValue()
    }
    
    func removeIssueFromFirebase(issue: Issue) {
        guard let user = DataManager.shared.currentUser else { return }
        let issuePath = "/users/\(user.oid)/issues/\(issue.id)"
        print(issuePath)
        self.firebaseReference.child(issuePath).removeValue()
        if let shopOid = user.shop?.oid {
            let ownerPath = "/users/\(issue.ownerOID)/issues/\(issue.id)"
            self.firebaseReference.child(ownerPath).removeValue()
        }
        
    }

	func testFirebase() {
		let update = [

			"test": [

				"hello": "world",
				"hola": "mundo"
			]
			] as [String : Any]

		self.firebaseReference.updateChildValues(update)
	}
}
