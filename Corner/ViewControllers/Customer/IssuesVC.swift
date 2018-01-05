//
//  MyMessagesViewController.swift
//  Corner
//
//  Created by MobileGod on 24/01/2017.
//  Copyright © 2017 BSE. All rights reserved.
//

import UIKit
import MGSwipeTableCell
import FirebaseMessaging

extension Notification.Name {
    public static let updateIssues = Notification.Name(rawValue: "updateIssues")
}


class IssuesVC: AppViewController {

	@IBOutlet weak var tableView:		UITableView!

	fileprivate let reuseIdOfCell = "MyMessageTableViewCell"
	fileprivate let reuseIdOfEmptyCell = "MessagesEmptyTableViewCell"
	fileprivate var selectedIndex: Int!
    fileprivate var issues = [Issue]()
    var unreadMessages = Set<String>()

	override func viewDidLoad() {
		super.viewDidLoad()
        IssuesManager.shared.writeUserOidToDatabase()
        registerForNotifications()
        reloadIssuesAndConversations()
        setupObservers()
		let nibMessageTableViewCell = UINib(nibName: "MyMessageTableViewCell", bundle: nil)
		let nibMessageEmptyTableViewCell = UINib(nibName: "MessagesEmptyTableViewCell", bundle: nil)

		tableView.register(nibMessageTableViewCell, forCellReuseIdentifier: reuseIdOfCell)
		tableView.register(nibMessageEmptyTableViewCell, forCellReuseIdentifier: reuseIdOfEmptyCell)

		tableView.rowHeight = 95.0
		tableView.delegate = self
		tableView.dataSource = self

		tableView.separatorColor = .lightGray
		tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
        reloadIssuesAndConversations()
		NotificationCenter.default.removeObserver(self, name: .gotIssues, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(reloadTable(_:)), name: .gotIssues, object: nil)

//		print("\nissues: \(issues)\n")
		tableView.reloadData()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		NotificationCenter.default.removeObserver(self, name: .gotIssues, object: nil)
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

		if segue.identifier == "showConversationsVC" {
			let issue = issues[selectedIndex]
			let destinationVC = segue.destination as! ConversationsVC
			destinationVC.issue = issue
		}
	}
    
    deinit {
        removeObservers()
    }
    
    func registerForNotifications() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.registerForNotifications()
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: .updateIssues, object: nil)
        NotificationCenter.default.removeObserver(self, name: .gotIncomingMessageInChat, object: nil)
    }
    
    func setupObservers() {
        NotificationCenter.default.addObserver(forName: .updateIssues, object: nil, queue: .main) { [weak self] (note) -> Void in
            guard let strongSelf = self else { return }
            strongSelf.reloadIssuesAndConversations()
        }
        
        NotificationCenter.default.addObserver(forName: .gotIncomingMessageInChat, object: nil, queue: .main) { [weak self] (note) -> Void in
            guard let strongSelf = self else { return }
            strongSelf.reloadIssuesAndConversations()
        }
    }
    
    func fetchUnreadConversations() {
        IssuesManager.shared.getUnreadIssuesFromFirebase(completion: { [weak self] (status, result) in
            guard let strongSelf = self else { return }
            switch status {
            case .newData:
                strongSelf.unreadMessages = Set(result.flatMap { $0 })
                strongSelf.tableView.reloadData()
            default:
                strongSelf.unreadMessages = Set<String>()
                strongSelf.tableView.reloadData()
                
            }
        })
        
    }

    
    func reloadIssuesAndConversations() {
        guard let user = DataManager.shared.currentUser else { return }
        print("I made it here")
        Issue.loadIssues(user: user) { [weak self] (issues, error) in
            guard let strongSelf = self else { return }
            strongSelf.issues = DataManager.shared.issues.sorted(by: {$0.updatedAt > $1.updatedAt})
            strongSelf.fetchUnreadConversations()
            strongSelf.tableView.reloadData()
        }
    }

	@objc fileprivate func reloadTable(_ notification: Notification) {

		self.tableView.reloadData()
	}
}


// MARK: - Private Functions
extension IssuesVC {

	fileprivate func configEmptyCell() -> MessagesEmptyTableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdOfEmptyCell) as! MessagesEmptyTableViewCell
		return cell
    }
    
    fileprivate func configCell(indexPath: IndexPath) -> MyMessageTableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdOfCell, for: indexPath) as! MyMessageTableViewCell
        let issue = issues[indexPath.row]
        cell.lblChatText.text = issue.message
        cell.imgAvatar.image = UIImage(named: "default-icon")
        let issueId = issue.id
        cell.imgUnread.isHidden = !unreadMessages.contains(issueId)
        let date = Date(timeIntervalSince1970: issue.createdAt)
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        cell.lblDate.text = formatter.string(from: date)

        // Right Editing Button To Close Message
//        var btnClose = UIButton(frame: CGRect(x: 0, y: 0, width: 110.0, height: 95.0))
//        btnClose.setTitleColor(UIColor.white, for: .normal)
//        btnClose = MGSwipeButton(title: "Delete",
//		                         backgroundColor: UIColor.init(red: 254, green: 56, blue: 36),
//		                         insets: UIEdgeInsets.init(top: 0, left: 30.0, bottom: 0.0, right: 30.0),
//		                         callback: { (cell) -> Bool in
//															self.Log("Close Message")
//															self.closeMessage(at: indexPath.row)
//															return true
//		})
//		cell.rightButtons = [btnClose]

		return cell
	}

	public func closeMessage(at index: Int) {
        
        IssuesManager.shared.removeIssueFromFirebase(issue: issues[index])

		issues.remove(at: index)
		tableView.deleteRows(at: [IndexPath.init(row: index, section: 0)], with: .fade)

		UIView.setAnimationsEnabled(false)
		tableView.reloadData()
		UIView.setAnimationsEnabled(true)
	}
}


// MARK: - TableView Delegate & Datasource
extension IssuesVC: UITableViewDelegate, UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return issues.count
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 95.0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return configCell(indexPath: indexPath)
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		selectedIndex = indexPath.row
        tableView.reloadRows(at: [indexPath], with: .automatic)

		tableView.deselectRow(at: indexPath, animated: true)

		performSegue(withIdentifier: "showConversationsVC", sender: self)
	}
}
