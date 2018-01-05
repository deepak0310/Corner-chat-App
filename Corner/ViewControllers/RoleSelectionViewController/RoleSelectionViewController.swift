//
//  RoleSelectionViewController.swift
//  Corner
//
//  Created by MobileGod on 24/01/2017.
//  Copyright © 2017 BSE. All rights reserved.
//

import UIKit

class RoleSelectionViewController: UIViewController {

	@IBOutlet weak var btnCustomer: UIButton!
	@IBOutlet weak var btnShop:		UIButton!

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		btnCustomer.setTitleColor(Color.AppGreen, for: .normal)
		btnShop.setTitleColor(Color.AppOrange, for: .normal)

		btnCustomer.setRoundedBorder(cornerRadius: 3.0, borderWidth: 1.0, borderColor: Color.AppGreen)
		btnShop.setRoundedBorder(cornerRadius: 3.0, borderWidth: 1.0, borderColor: Color.AppOrange)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

// MARK: - Button Clicks
extension RoleSelectionViewController {

	// Clicked by Customer
	@IBAction func btnCustomerClicked(_ sender: UIButton) {

		let storyboard = UIStoryboard(name: "Customer", bundle: nil)
		let navVC = storyboard.instantiateViewController(withIdentifier: "CustomerNavigationViewController")
		present(navVC, animated: true, completion: nil)

		Log("Entered Customer Role")
	}

	// Clicked by Shopper
	@IBAction func btnShopperClicked(_ sender: UIButton) {

		let navVC = shopStoryboard.instantiateViewController(withIdentifier: "StoreNavigationViewController") as! StoreNavigationViewController
		present(navVC, animated: true, completion: nil)
		Log("Entered Store Role")
	}
}
