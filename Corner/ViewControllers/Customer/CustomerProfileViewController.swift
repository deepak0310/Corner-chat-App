//
//  CustomerProfileViewController.swift
//  Corner
//
//  Created by MobileGod on 01/02/2017.
//  Copyright © 2017 BSE. All rights reserved.
//

import UIKit
import AlamofireImage

class CustomerProfileViewController: AppViewController {
    
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgPhoto.setCornerRadius(cornerRadius: imgPhoto.frame.size.width / 2)
        
        loadProfile()
    }
    
    @IBAction func onPressLogoutButton(_ sender: Any) {
        
        User.forceLogout()
        let vc = RoleSelectionViewController(nibName: "RoleSelectionViewController", bundle: nil)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window?.rootViewController = vc
        
    }
    
}


extension CustomerProfileViewController {
    
    fileprivate func loadProfile() {
        guard let user = DataManager.shared.currentUser else { return }
        nameLabel.text = user.fullName
        lblAddress.text = user.location
        
        guard let count = APIManager.keychain[Prefs.avatarKey]?.characters.count else { return }
        if count > 0 {
            
            var urlString = APIManager.keychain[Prefs.avatarKey]!
            if !(urlString.hasPrefix("http")){
                urlString = "\(AppConfig.apiHost)\(urlString)"
            }
            self.imgPhoto.af_setImage(withURL:  URL(string:urlString)!)
            
        }
        
    }
    
}
