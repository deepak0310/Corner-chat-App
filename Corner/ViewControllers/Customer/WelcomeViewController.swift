//
//  WelcomeViewController.swift
//  Corner
//
//  Created by MobileGod on 24/01/2017.
//  Copyright © 2017 BSE. All rights reserved.
//

import UIKit

class WelcomeViewController: AppViewController {

	@IBOutlet weak var btnNotNow:			UIButton!
	@IBOutlet weak var btnCreateMessage:	UIButton!
	
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		btnNotNow.setRoundedBorder(cornerRadius: 3.0, borderWidth: 1.0, borderColor: UIColor.white)
		
		btnCreateMessage.setCornerRadius(cornerRadius: 3.0)
		btnCreateMessage.setTitleColor(Color.AppLightGreen, for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if segue.identifier == "gotoNotNow" {
		
			let vc = segue.destination as! CustomerTabBarViewController
			vc.selectedIndex = 0
		} else if segue.identifier == "gotoCreateMessage" {
		
			let vc = segue.destination as! CustomerTabBarViewController
			vc.selectedIndex = 2
		}
    
    UserDefaults.standard.set(true, forKey: Prefs.firstLaunch)
	}
}
