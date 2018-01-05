//
//  StoreLogInViewController.swift
//  Corner
//
//  Created by MobileGod on 19/02/2017.
//  Copyright © 2017 BSE. All rights reserved.
//

import UIKit

class StoreSignInViewController: UIViewController {
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSignIn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.AppOrange
        
        btnSignIn.setRoundedBorder(cornerRadius: 3.0, borderWidth: 1.0, borderColor: Color.white)
        setSignInButtonEnable(enabled: false)
        
        if APIManager.keychain[Prefs.tokenKey] == nil {
            NotificationCenter.default.addObserver(self, selector: #selector(transitionToNextScreen(notif:)), name: .authenticated, object: nil)
        }
        
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        
        if txtUsername.text!.isEmpty || txtPassword.text!.isEmpty {
            
            setSignInButtonEnable(enabled: false)
            
        } else {
            
            setSignInButtonEnable(enabled: true)
        }
    }
    
    func transitionToNextScreen(notif:Notification) {
        
        DispatchQueue.main.async {
            Shop.fetchAll()
            self.performSegue(withIdentifier: "showIssuesNav2", sender: self)
        }
    }
}

extension StoreSignInViewController {
    
    fileprivate func setSignInButtonEnable(enabled: Bool) {
        
        if enabled {
            
            btnSignIn.backgroundColor = Color.white
            btnSignIn.setTitleColor(Color.orange.base, for: .normal)
            btnSignIn.isEnabled = true
            
        } else {
            
            btnSignIn.backgroundColor = Color.clear
            btnSignIn.setTitleColor(Color.white, for: .normal)
            btnSignIn.isEnabled = false
        }
    }
}

extension StoreSignInViewController {
    
    @IBAction func btnSignInClicked(_ sender: UIButton) {
        
        if txtUsername.text!.isEmpty {
            showAlertWithTitle("Error", message:"Please enter user name", toFocus:txtUsername)
            return
        }
        if txtPassword.text!.isEmpty {
            showAlertWithTitle("Error", message:"Password required.", toFocus:txtPassword)
            return
        }
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        User.signin(email: self.txtUsername.text!, password: self.txtPassword.text!) { (user, error, json) in
            
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if let err = json?["errors"], user == nil {
                
                var errorString = ""
                for (_,data) in err.enumerated() {
                    if data.1.stringValue.characters.count > 0 {
                        errorString = errorString + data.1.stringValue + " "
                    }
                }
                self.showAlert("Error", message: errorString, ok: {})
            } else {
                if let user = user {
                    print ("shop employee: \(user.role)")
                    guard let x = user.shop?.oid else { return }
                    print("user belongs to shop: \(x)")
                }
            }
        }
    }
    
    @IBAction func whiteXButtonTapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

}
