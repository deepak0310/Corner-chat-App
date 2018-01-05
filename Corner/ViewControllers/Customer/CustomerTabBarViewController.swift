//
//  CustomerTabBarViewController.swift
//  Corner
//
//  Created by MobileGod on 24/01/2017.
//  Copyright © 2017 BSE. All rights reserved.
//

import UIKit

class CustomerTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		tabBar.backgroundImage = UIImage()
		tabBar.shadowImage = UIImage()
		tabBar.isTranslucent = true
		tabBar.backgroundColor = Color.AppGreen
		tabBar.tintColor = Color.white
		tabBar.unselectedItemTintColor = UIColor.white
		
		let numberOfItems = CGFloat(tabBar.items!.count)
		let tabBarItemSize = CGSize(width: tabBar.frame.width / numberOfItems, height: tabBar.frame.height-1)
		tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: Color.AppLightGreen, size: tabBarItemSize).resizableImage(withCapInsets: UIEdgeInsets.zero)
		
		// remove default border
		tabBar.frame.size.width = self.view.frame.width + 4
//        tabBar.frame.origin.x = -2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
