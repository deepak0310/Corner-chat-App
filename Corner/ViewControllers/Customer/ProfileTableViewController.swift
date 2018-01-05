//
//  ProfileTableViewController.swift
//  Corner
//
//  Created by MobileGod on 26/01/2017.
//  Copyright © 2017 BSE. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {

	
	@IBOutlet weak var navBar: UINavigationItem!
	@IBOutlet weak var imgPhoto:		UIImageView!
	@IBOutlet weak var swtNotification: UISwitch!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		for subView in view.subviews {
			if subView is UINavigationBar {
				
				let navBar = subView as! UINavigationBar
				
				navBar.setBackgroundImage(UIImage(), for: .default)
				navBar.shadowImage = UIImage()
				navBar.isTranslucent = true
				navBar.tintColor = Color.white
				navBar.backgroundColor = Color.AppGreen
				navBar.titleTextAttributes = [NSForegroundColorAttributeName: Color.white]
				for item in navBar.items! {
					item.titleLabel.textColor = Color.white
				}
			}
		}
		
		tabBarController?.tabBar.backgroundImage = UIImage()
		tabBarController?.tabBar.shadowImage = UIImage()
		tabBarController?.tabBar.isTranslucent = true
		tabBarController?.tabBar.backgroundColor = Color.AppGreen
		
		view.backgroundColor = Color.AppGreen

        imgPhoto.setCornerRadius(cornerRadius: imgPhoto.frame.size.width / 2)
		
		swtNotification.tintColor = Color.AppBlue
		swtNotification.onTintColor = Color.AppBlue
		
		tableView.separatorColor = UIColor.clear
		tableView.bounces = false
		tableView.allowsSelection = false
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}



// 
// MARK: - UITableView Delegate
///
///
extension ProfileTableViewController {
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		
		switch section
		{
		case 0:
			return 0
		case 1:
			return 55.0
		default:
			return 100.0
		}
	}
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		
		let view = UIView(frame: CGRect.init(origin: CGPoint.zero, size: screenSize))
		view.backgroundColor = UIColor.clear
		
		return view
	}
}
