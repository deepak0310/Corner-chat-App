//
//  MessageDetailViewController.swift
//  Corner
//
//  Created by MobileGod on 26/01/2017.
//  Copyright © 2017 BSE. All rights reserved.
//

import UIKit

class ConversationsVC: AppViewController {

	public var issue: Issue?
	@IBOutlet weak var tableView:	UITableView!
//	@IBOutlet weak var btnClose:	UIButton!

	fileprivate let reuseIdOfDetailImageCell = "MessageDetailImageTableViewCell"
	fileprivate let reuseIdOfDetailRespoCell = "MessageDetailResponseTableViewCell"
    var unreadMessages = Set<String>()
    var sortedConversations = [Conversation]()

	override func viewDidLoad() {
		super.viewDidLoad()
        setupObservers()
        fetchUnreadConversations()
		let nibMessageDetailImage = UINib.init(nibName: "MessageDetailImageTableViewCell", bundle: nil)
		let nibMessageDetailResponse = UINib.init(nibName: "MessageDetailResponseTableViewCell", bundle: nil)
		tableView.register(nibMessageDetailImage, forCellReuseIdentifier: reuseIdOfDetailImageCell)
		tableView.register(nibMessageDetailResponse, forCellReuseIdentifier: reuseIdOfDetailRespoCell)
		tableView.backgroundColor = UIColor.lightGray
		tableView.delegate = self
		tableView.dataSource = self
        guard let issue = issue else { return }
        sortedConversations = issue.conversations.sorted(by: {$0.updatedAt > $1.updatedAt})
        IssuesManager.shared.markIssueRead(issue: issue)

//		btnClose.backgroundColor = Color.AppBlue
//		btnClose.setCornerRadius(cornerRadius: 3.0)
//		btnClose.setBorderShadow(radius: 8.0, color: UIColor.gray)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
        guard let user = DataManager.shared.currentUser else { return }
        title = user.role == "customer" ? "Shop Responses" : "Issue"
	}
    
    deinit {
        removeObservers()
    }
    
    fileprivate func setupObservers() {
        NotificationCenter.default.addObserver(forName: .gotIncomingMessageInChat, object: nil, queue: .main) { [weak self] (note) -> Void in
            guard let strongSelf = self else { return }
            strongSelf.fetchUnreadConversations()
        }

    }
    
    fileprivate func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: .gotIncomingMessageInChat, object: nil)
    }
    
    func fetchUnreadConversations() {
        IssuesManager.shared.getUnreadConversationsFromFirebase(completion: { [weak self] (status, result) in
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
}

// MARK: - Cell Configuration
extension ConversationsVC {

	fileprivate func configDetailImageCell() -> MessageDetailImageTableViewCell {

		let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdOfDetailImageCell) as! MessageDetailImageTableViewCell
        cell.setupCell(issue: issue)
		return cell
	}

	fileprivate func configDetailResponseCell(indexPath: IndexPath) -> MessageDetailResponseTableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdOfDetailRespoCell, for: indexPath) as! MessageDetailResponseTableViewCell
        let conversation = sortedConversations[indexPath.row]
        let conversationId = conversation.id
        cell.imgUnread.isHidden = !unreadMessages.contains(conversationId)
        cell.lblSellerName.text = conversation.shopName
        let lastPosterName = conversation.lastPosterName
        cell.imgShop.image = conversation.correspondentOID == "5c43b67a580c2a7572594b60dd6560ee1d59b8fd" ? UIImage(named: "default-shop-icon") : UIImage(named: "default-icon")


        cell.lblShopName.text = "Last Post by \(lastPosterName)"
        
        let unformattedDate = conversation.updatedAt
        let date = Date.init(timeIntervalSince1970: unformattedDate)
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        cell.lblDate.text = formatter.string(from: date)
        cell.lblResponseMessage.text = conversation.lastMessage
        
        return cell
    }
}

extension ConversationsVC {

	@IBAction func btnBackClicked(_ sender: UIBarButtonItem) {
		Log("< Back Clicked")
		_ = navigationController?.popViewController(animated: true)
	}

	@IBAction func btnCloseClicked(_ sender: UIButton) {

		print("buttonclose clicked")
	}
}

// MARK: - UITableViewDelegate, UITableViewDatasource
extension ConversationsVC: UITableViewDelegate, UITableViewDataSource {

	func numberOfSections(in tableView: UITableView) -> Int {
		return 3
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 ? sortedConversations.count : 1
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

		if section == 1 {

			return 55.0

		} else if section == 2 {

			return 120.0

		} else {

			return 0

		}
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

		if indexPath.section == 0 {

			return screenSize.width + 116.0

		} else if indexPath.section == 1 {

			return 66.0

		} else {
			return 0
		}
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let user = DataManager.shared.currentUser else { return UIView() }

		if section == 1 {

			let rect = CGRect(x: 0, y: 0, width: screenSize.width, height: 66.0)
			let view = UIView(frame: rect)
			view.backgroundColor = UIColor.lightGray

			let lblTitle = UILabel(frame: CGRect.init(x: 18.0, y: 30.0, width: screenSize.width - 20.0, height: 20.0))
			lblTitle.font = UIFont.boldSystemFont(ofSize: 13.0)
			lblTitle.textColor = UIColor.gray
			lblTitle.text = user.role == "customer" ? "SHOP RESPONSES" : ""

			view.addSubview(lblTitle)

			return view

		} else if section == 2 {

			let rect = CGRect(x: 0, y: 0, width: screenSize.width, height: 120.0)
			let view = UIView(frame: rect)
			view.backgroundColor = UIColor.clear

			return view

		} else {
			return UIView()
		}
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		if indexPath.section == 0 {

			return configDetailImageCell()

		} else if indexPath.section == 1 {

			return configDetailResponseCell(indexPath: indexPath)

		} else {
			return UITableViewCell()
		}
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        let conversation = sortedConversations[indexPath.row]
        
        let conversationId = conversation.id
        unreadMessages.remove(conversationId)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        let chatController = ChatDetailVC()
        chatController.otherUser = User()
        chatController.issue = issue
		chatController.conversation = conversation

		self.title = ""

		self.navigationController?.pushViewController(chatController, animated: true)
	}
}
