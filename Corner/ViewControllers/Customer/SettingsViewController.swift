//
//  SettingsViewController.swift
//  Corner
//
//  Created by MobileGod on 24/01/2017.
//  Copyright © 2017 BSE. All rights reserved.
//

import UIKit

class SettingsViewController: AppViewController {

	@IBOutlet weak var tableView:	UITableView!
	
	fileprivate let arrSetting		= ["Share Corner",
	                          		   "Contact",
	                          		   "User Agreement"]
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		tableView.isScrollEnabled = false
		tableView.delegate = self
		tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPressLogoutButton(_ sender: Any) {
        User.forceLogout()
        let vc = RoleSelectionViewController(nibName: "RoleSelectionViewController", bundle: nil)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window?.rootViewController = vc
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
	
		if section == 0 {
			return arrSetting.count
		} else {
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
	
		if section == 0 {
			return 0
		} else {
			return screenSize.height
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 45.0
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		
		let view = UIView(frame: CGRect.init(origin: CGPoint.zero, size: screenSize))
		view.backgroundColor = UIColor.clear
		
		return view
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
		cell.accessoryType = .disclosureIndicator
		cell.textLabel?.text = arrSetting[indexPath.row]
		cell.textLabel?.textColor = UIColor.darkGray
		cell.textLabel?.font = UIFont(name: "AvenirNext-Regular", size: 15.0)!
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		tableView.deselectRow(at: indexPath, animated: true)
	}
}
