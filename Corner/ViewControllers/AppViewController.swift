//
//  AppViewController.swift
//  Corner
//
//  Created by MobileGod on 01/02/2017.
//  Copyright © 2017 BSE. All rights reserved.
//

import UIKit

class AppViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()


		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
		self.navigationController?.navigationBar.shadowImage = UIImage()
		self.navigationController?.navigationBar.isTranslucent = true
		self.navigationController?.navigationBar.tintColor = Color.white
		self.navigationController?.navigationBar.backgroundColor = Color.AppGreen
		self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Color.white, NSFontAttributeName: UIFont.init(name: "AvenirNext-Medium", size: 17.0)!]

		view.backgroundColor = Color.AppGreen
	}
}
