//
//  WelcomeViewController.swift
//  Corner
//
//  Created by MobileGod on 27/01/2017.
//  Copyright © 2017 BSE. All rights reserved.
//

import UIKit

class WelcomeStoreViewController: UIViewController {

	@IBOutlet weak var btnLogIn: UIButton!

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = Color.AppBlue

		btnLogIn.setTitleColor(Color.AppLightGreen, for: .normal)
		btnLogIn.setCornerRadius(cornerRadius: 3.0)

	}

	override func viewWillAppear(_ animated: Bool) {

		if APIManager.keychain[Prefs.tokenKey] != nil {
			self.performSegue(withIdentifier: "showIssuesNav", sender: self)
		}
	}
    
    
    @IBAction func whiteXButtonTapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}
