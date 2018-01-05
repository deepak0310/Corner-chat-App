//
//  StoreSettingViewController.swift
//  Corner
//
//  Created by MobileGod on 31/01/2017.
//  Copyright © 2017 BSE. All rights reserved.
//

import UIKit

class StoreSettingViewController: AppViewController {

	@IBOutlet weak var tableView:	UITableView!
	
	let reusableIdOfInfoCell			= "StoreSettingInfoTableViewCell"
	let reusableIdOfNotificationCell	= "StoreSettingNotificationTableViewCell"
	
	var arrNotificationOption			= ["New Message - All",
	                         			   "New Message - Product",
	                         			   "New Message - Service",
	                         			   "New Response"]
	var arrSwichValues: [Bool]			= [true, true, true, true]
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		
		let nibInfoCell = UINib(nibName: "StoreSettingInfoTableViewCell", bundle: nil)
		let nibNotificationCell = UINib(nibName: "StoreSettingNotificationTableViewCell", bundle: nil)
		tableView.register(nibInfoCell, forCellReuseIdentifier: reusableIdOfInfoCell)
		tableView.register(nibNotificationCell, forCellReuseIdentifier: reusableIdOfNotificationCell)
		tableView.rowHeight = 0.0
		tableView.allowsSelection = false
		tableView.backgroundColor = UIColor(red: 239, green: 239, blue: 244)
		tableView.tableFooterView = UIView()
		tableView.delegate		= self
		tableView.dataSource	= self
		
    }
  
  @IBAction func logOutShopUser(_ sender: Any) {
    User.forceLogout()
    let vc = RoleSelectionViewController(nibName: "RoleSelectionViewController", bundle: nil)
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    appDelegate?.window?.rootViewController = vc
    
  }
  
}

//
// MARK: - Private Functions
///
///

extension StoreSettingViewController {

	fileprivate func configInfoCell() -> StoreSettingInfoTableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdOfInfoCell) as! StoreSettingInfoTableViewCell
		cell.setupCell()
		cell.btnEdit.addTarget(self, action: #selector(gotoStoreEditingVC), for: .touchUpInside)
		
		return cell
	}
	
	fileprivate func configNotificationCell(at indexPath: IndexPath) -> StoreSettingNotificationTableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdOfNotificationCell, for: indexPath) as! StoreSettingNotificationTableViewCell
		
		cell.lblTitle.text = arrNotificationOption[indexPath.row]
		cell.swtOption.tag = indexPath.row
		cell.swtOption.isOn = arrSwichValues[indexPath.row]
		cell.swtOption.addTarget(self, action: #selector(switchChanged(sender:)), for: .valueChanged)
		
		return cell
	}
	
	@objc private func gotoStoreEditingVC() {
	
		Log("Edit Button Clicked")
		performSegue(withIdentifier: "gotoStoreSettingEditViewController", sender: self)
	}
	
	@objc private func switchChanged(sender: UISwitch) {
		
		Log("Switch changed")
		arrSwichValues[sender.tag] = !arrSwichValues[sender.tag]
	}
    
    @IBAction func unwindToSettings(segue:UIStoryboardSegue) {
        tableView.reloadData()
    }

}



//
// MARK: - Button Click Events
///
///

extension StoreSettingViewController {
	
	@IBAction func barBtnBackClicked(_ sender: UIBarButtonItem) {
		_ = navigationController?.popViewController(animated: true)
	}
}




//
// MARK: - UITableView Delegate / Datasource 
///
///

extension StoreSettingViewController: UITableViewDelegate, UITableViewDataSource {

	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		if section == 0 {
			return 1
		} else if section == 1 {
			return arrNotificationOption.count
		} else {
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		
		if section == 1 {
			return 104.0
		} else {
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		if indexPath.section == 0 {
			return 168
		} else if indexPath.section == 1 {
			return 50.0
		} else {
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		
		if section == 1 {
			
			let rect = CGRect(x: 0, y: 0, width: screenSize.width, height: 104.0)
			let view = UIView(frame: rect)
			
			let lblTitle = UILabel(frame: CGRect.init(x: 18.0, y: 80.0, width: screenSize.width - 20.0, height: 20.0))
			lblTitle.font = UIFont(name: "AvenirNext-Regular", size: 13)
			lblTitle.textColor = UIColor(red: 109, green: 109, blue: 114)
			lblTitle.text = "NOTIFICATIONS"
			
			view.addSubview(lblTitle)
			
			return view
			
		} else {
			return UIView()
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		if indexPath.section == 0 {
			return configInfoCell()
		} else if indexPath.section == 1 {
			return configNotificationCell(at: indexPath)
		} else {
			return UITableViewCell()
		}
	}
}
