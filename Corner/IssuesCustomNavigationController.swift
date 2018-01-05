//
//  IssuesCustomNavigationController.swift
//  Corner
//
//  Created by Joshua Auriemma on 5/26/17.
//  Copyright © 2017 BSE. All rights reserved.
//

import UIKit

class IssuesCustomNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set pageIndicatorTintColor and currentPageIndicatorTintColor
        // only for the following stack of UIViewControllers
        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = Color.AppLightGreen
        pageControl.currentPageIndicatorTintColor = Color.AppGreen
    }

}
