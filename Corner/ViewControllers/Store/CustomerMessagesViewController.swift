//
//  CustomerMessagesViewController.swift
//  Corner
//
//  Created by MobileGod on 30/01/2017.
//  Copyright © 2017 BSE. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class CustomerMessagesViewController: AppViewController {

	@IBOutlet weak var navBar:			UINavigationBar!
	@IBOutlet weak var viewSearchField: UIView!
	@IBOutlet weak var viewSearchBG:	UIView!
	@IBOutlet weak var txtSearch:		UITextField!
	@IBOutlet weak var segController:	UISegmentedControl!
	@IBOutlet weak var btnAll:			UIButton!
	@IBOutlet weak var btnService:		UIButton!
	@IBOutlet weak var btnProducts:		UIButton!
	@IBOutlet weak var btnOther:		UIButton!
	@IBOutlet weak var tableView:		UITableView!


	fileprivate var arrAllCustomerMessage = [CustomerMessage]()
	fileprivate var arrFilteredMessage = [CustomerMessage]()
	fileprivate let reusableCellId = "CustomerMessageTableViewCell"

	override func viewDidLoad() {
		super.viewDidLoad()

		navBar.tintColor = Color.white

		viewSearchField.backgroundColor = Color.AppGreen
		viewSearchField.isHidden = true
		viewSearchBG.backgroundColor = UIColor(red: 229, green: 229, blue: 229)
		viewSearchBG.setCornerRadius(cornerRadius: 6.0)
		txtSearch.textColor = UIColor(red: 74, green: 74, blue: 74)
		txtSearch.font = UIFont(name: "AvenirNext-Regular", size: 18.0)
		txtSearch.delegate = self

		segController.tintColor = Color.AppOrange
		segController.setTitleTextAttributes([NSFontAttributeName: UIFont.init(name: "AvenirNext-Medium", size: 13.0)!], for: .normal)

		let nib = UINib(nibName: "CustomerMessageTableViewCell", bundle: nil)
		tableView.register(nib, forCellReuseIdentifier: reusableCellId)
		tableView.separatorInset = UIEdgeInsets.zero
		tableView.rowHeight = 88.0
		tableView.backgroundColor = UIColor.init(red: 239, green: 239, blue: 244)
		tableView.tableFooterView = UIView()
		tableView.delegate = self
		tableView.dataSource = self

		selectButton(index: 0)

		loadAllMessages()
	}
}

extension CustomerMessagesViewController {

	fileprivate func selectButton(index: Int) {

		let arrButtons = [btnAll, btnService, btnProducts, btnOther]
		for button in arrButtons {
			button?.setTitleColor(Color.darkGray, for: .normal)
		}
		arrButtons[index]?.setTitleColor(Color.AppLightGreen, for: .normal)
	}

	fileprivate func loadAllMessages() {

		arrAllCustomerMessage = [CustomerMessage.init(id: "", customerId: "", name: "Customer Name", category: "Service", text: "Looking for a new Kask helmet to match this kit. And, if you have Scott…", date: "8:53 am", status: "New"),
		                         CustomerMessage.init(id: "1", customerId: "", name: "Customer Name", category: "Other", text: "Looking for a new Kask helmet to match this kit. And, if you have Scott…", date: "8:53 am", status: "New"),
		                         CustomerMessage.init(id: "2", customerId: "", name: "Customer Name", category: "Service", text: "Looking for a new Kask helmet to match this kit. And, if you have Scott…", date: "8:53 am", status: "New"),
		                         CustomerMessage.init(id: "3", customerId: "", name: "Customer Name", category: "Service", text: "Looking for a new Kask helmet to match this kit. And, if you have Scott…", date: "8:53 am", status: "New"),
		                         CustomerMessage.init(id: "4", customerId: "", name: "Customer Name", category: "Products", text: "Looking for a new Kask helmet to match this kit. And, if you have Scott…", date: "8:53 am", status: "Responded"),
		                         CustomerMessage.init(id: "5", customerId: "", name: "Customer Name", category: "Service", text: "Looking for a new Kask helmet to match this kit. And, if you have Scott…", date: "8:53 am", status: "New"),
		                         CustomerMessage.init(id: "6", customerId: "", name: "Customer Name", category: "Other", text: "Looking for a new Kask helmet to match this kit. And, if you have Scott…", date: "8:53 am", status: "New"),
		                         CustomerMessage.init(id: "7", customerId: "", name: "Customer Name", category: "Service", text: "Looking for a new Kask helmet to match this kit. And, if you have Scott…", date: "8:53 am", status: "Closed"),
		                         CustomerMessage.init(id: "8", customerId: "", name: "Customer Name", category: "Service", text: "Looking for a new Kask helmet to match this kit. And, if you have Scott…", date: "8:53 am", status: "Closed"),
		                         CustomerMessage.init(id: "9", customerId: "", name: "Customer Name", category: "Service", text: "Looking for a new Kask helmet to match this kit. And, if you have Scott…", date: "8:53 am", status: "New"),
		                         CustomerMessage.init(id: "10", customerId: "", name: "Customer Name", category: "Other", text: "Looking for a new Kask helmet to match this kit. And, if you have Scott…", date: "8:53 am", status: "New"),
		                         CustomerMessage.init(id: "11", customerId: "", name: "Customer Name", category: "Service", text: "Looking for a new Kask helmet to match this kit. And, if you have Scott…", date: "8:53 am", status: "Responded"),
		                         CustomerMessage.init(id: "12", customerId: "", name: "Customer Name", category: "Products", text: "Looking for a new Kask helmet to match this kit. And, if you have Scott…", date: "8:53 am", status: "New"),
		                         CustomerMessage.init(id: "13", customerId: "", name: "Customer Name", category: "Service", text: "Looking for a new Kask helmet to match this kit. And, if you have Scott…", date: "8:53 am", status: "New"),
		                         CustomerMessage.init(id: "14", customerId: "", name: "Customer Name", category: "Products", text: "Looking for a new Kask helmet to match this kit. And, if you have Scott…", date: "8:53 am", status: "Responded"),
		                         CustomerMessage.init(id: "15", customerId: "", name: "Customer Name", category: "Other", text: "Looking for a new Kask helmet to match this kit. And, if you have Scott…", date: "8:53 am", status: "New"),
		                         CustomerMessage.init(id: "16", customerId: "", name: "Customer Name", category: "Service", text: "Looking for a new Kask helmet to match this kit. And, if you have Scott…", date: "8:53 am", status: "Closed"),
		                         CustomerMessage.init(id: "17", customerId: "", name: "Customer Name", category: "Service", text: "Looking for a new Kask helmet to match this kit. And, if you have Scott…", date: "8:53 am", status: "New"),
		                         CustomerMessage.init(id: "18", customerId: "", name: "Customer Name", category: "Products", text: "Looking for a new Kask helmet to match this kit. And, if you have Scott…", date: "8:53 am", status: "New"),
		                         CustomerMessage.init(id: "19", customerId: "", name: "Customer Name", category: "Other", text: "Looking for a new Kask helmet to match this kit. And, if you have Scott…", date: "8:53 am", status: "New")
		]

		updateTable(statusIndex: 0, categoryIndex: 0)
	}

	fileprivate func updateTable(statusIndex: Int, categoryIndex: Int) {

		if statusIndex >= 3 || categoryIndex >= 4 { return }

		let arrStatus = ["New", "Responded", "Closed"]
		let arrCategory = ["All", "Service", "Products", "Other"]

		if categoryIndex == 0 {

			arrFilteredMessage = arrAllCustomerMessage.filter{$0.status == arrStatus[statusIndex]}

		} else {

			arrFilteredMessage = arrAllCustomerMessage.filter{$0.status == arrStatus[statusIndex] && $0.category == arrCategory[categoryIndex]}
		}

		tableView.reloadData()
	}

	fileprivate func configTableViewCell(indexPath: IndexPath) -> CustomerMessageTableViewCell {

		let cell = tableView.dequeueReusableCell(withIdentifier: reusableCellId, for: indexPath) as! CustomerMessageTableViewCell

		cell.imgAvatar.backgroundColor = UIColor.darkGray
		cell.lblCategory.text = arrFilteredMessage[indexPath.row].category
		cell.lblDate.text = arrFilteredMessage[indexPath.row].date
		cell.lblMessage.text = arrFilteredMessage[indexPath.row].text

		cell.rightButtons = []
		if arrFilteredMessage[indexPath.row].status != "Closed" {

			// Right Editing Button To Close Message
			var btnClose = UIButton(frame: CGRect(x: 0, y: 0, width: 100.0, height: 93.0))
			btnClose.setTitleColor(UIColor.white, for: .normal)
			btnClose = MGSwipeButton(title: "Delete",
			                         backgroundColor: UIColor.init(red: 254, green: 56, blue: 36),
			                         insets: UIEdgeInsets.init(top: 20, left: 20.0, bottom: 20.0, right:20.0),
			                         callback: { (cell) -> Bool in
																self.Log("Close Message")
																self.closeMessage(at: indexPath.row)

																return true
			})
			cell.rightButtons = [btnClose]
		}

		return cell
	}

	private func closeMessage(at index: Int) {

		showAlertSheet("This conversation was a success! The customer is coming in!", message: "", yes: "Yes", no: "No") {

			let selIndex = self.arrAllCustomerMessage.index(where: {$0.id == self.arrFilteredMessage[index].id})
			self.arrAllCustomerMessage[selIndex!].status = "Closed"
			self.arrFilteredMessage.remove(at: index)

			let indexPath = IndexPath(row: index, section: 0)
			self.tableView.deleteRows(at: [indexPath], with: .fade)

			UIView.setAnimationsEnabled(false)
			self.tableView.reloadData()
			UIView.setAnimationsEnabled(true)
		}
	}
}

extension CustomerMessagesViewController {

	// Seg Control Value Changed
	@IBAction func segControlValueDidChange(_ sender: UISegmentedControl) {

		Log("Switched Segmented Controller")
		updateTable(statusIndex: sender.selectedSegmentIndex, categoryIndex: 0)
		selectButton(index: 0)
	}

	// Category Buttons Clicked
	@IBAction func btnAllClicked(_ sender: UIButton) {

		Log("All Categories Selected")
		if sender.titleColor(for: .normal) == Color.AppBlue { return }

		updateTable(statusIndex: segController.selectedSegmentIndex, categoryIndex: 0)
		selectButton(index: 0)
	}

	@IBAction func btnServiceClicked(_ sender: UIButton) {

		Log("Service Category Selected")
		if sender.titleColor(for: .normal) == Color.AppBlue { return }

		updateTable(statusIndex: segController.selectedSegmentIndex, categoryIndex: 1)
		selectButton(index: 1)
	}

	@IBAction func btnProductsClicked(_ sender: UIButton) {

		Log("Products Category Selected")
		if sender.titleColor(for: .normal) == Color.AppBlue { return }

		updateTable(statusIndex: segController.selectedSegmentIndex, categoryIndex: 2)
		selectButton(index: 2)
	}

	@IBAction func btnOtherClicked(_ sender: UIButton) {

		Log("Other Category Selected")
		if sender.titleColor(for: .normal) == Color.AppBlue { return }

		updateTable(statusIndex: segController.selectedSegmentIndex, categoryIndex: 3)
		selectButton(index: 3)
	}

	// Search BarButton Clicked
	@IBAction func barBtnSearchClicked(_ sender: UIBarButtonItem) {

		Log("Search \(txtSearch.text!)")
		viewSearchField.isHidden = false
		txtSearch.becomeFirstResponder()
	}

	// Search Close BarButton Clicked
	@IBAction func barBtnSearchCloseClicked(_ sender: UIBarButtonItem) {

		Log("Search \(txtSearch.text!)")
		viewSearchField.isHidden = true
		txtSearch.text = ""
		self.view.endEditing(true)
	}
}

extension CustomerMessagesViewController: UITableViewDelegate, UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return arrFilteredMessage.count
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 93.0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return configTableViewCell(indexPath: indexPath)
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		tableView.deselectRow(at: indexPath, animated: true)
	}
}

extension CustomerMessagesViewController: UITextFieldDelegate {

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {

		self.view.endEditing(true)
		return false
	}
}
