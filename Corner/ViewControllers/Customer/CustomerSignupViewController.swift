//
//  CustomerSignupViewController.swift
//  Corner
//
//  Created by MobileGod on 02/02/2017.
//  Copyright © 2017 BSE. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import GoogleSignIn
import SwiftyJSON

class CustomerSignupViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var facebookSignInButton: UIButton!
    @IBOutlet weak var googleSignInButton: UIButton!
    @IBOutlet weak var btnDone:            UIButton!
    
    @IBOutlet weak var txtFullName:        UITextField!
    @IBOutlet weak var txtEmail:        UITextField!
    @IBOutlet weak var txtPassword:        UITextField!
    
    var alertController:UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.AppLightGreen
        
        facebookSignInButton.setCornerRadius(cornerRadius: 3.0)
        facebookSignInButton.titleLabel?.numberOfLines = 2
        
        googleSignInButton.setCornerRadius(cornerRadius: 3.0)
        googleSignInButton.titleLabel?.numberOfLines = 2
        
        btnDone.setRoundedBorder(cornerRadius: 3.0, borderWidth: 1.0, borderColor: Color.white)
        setDoneButtonDisable()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        if APIManager.keychain[Prefs.tokenKey] == nil {
            NotificationCenter.default.addObserver(self, selector: #selector(goToWelcome(notif:)), name: .authenticated, object: nil)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if APIManager.keychain[Prefs.tokenKey] != nil {
            let presentedWelcomeScreen = UserDefaults.standard.bool(forKey: Prefs.firstLaunch)
            if presentedWelcomeScreen {
                self.performSegue(withIdentifier: "goToMainView", sender: self)
            } else {
                self.performSegue(withIdentifier: "gotoCustomerWelcomeVC", sender: self)
            }
        }
        
    }
    
    @objc fileprivate func goToWelcome(notif: Notification) {
        if APIManager.keychain[Prefs.tokenKey] != nil {
            DispatchQueue.main.async {
                Shop.fetchAll()
                let presentedWelcomeScreen = UserDefaults.standard.bool(forKey: Prefs.firstLaunch)
                if presentedWelcomeScreen {
                    self.performSegue(withIdentifier: "goToMainView", sender: self)
                } else {
                    self.performSegue(withIdentifier: "gotoCustomerWelcomeVC", sender: self)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToMainView" {
            let vc = segue.destination as! CustomerTabBarViewController
            vc.selectedIndex = 0
        }
        
    }
    
}

extension CustomerSignupViewController {
    
    fileprivate func setDoneButtonEnable() {
        
        btnDone.setTitleColor(Color.white, for: .normal)
        btnDone.backgroundColor = Color.AppGreen
        btnDone.isEnabled = true
    }
    
    fileprivate func setDoneButtonDisable() {
        
        btnDone.setTitleColor(UIColor.white, for: .normal)
        btnDone.backgroundColor = Color.clear
        btnDone.isEnabled = false
    }
    
    fileprivate func registerUserOnDevice(id: String) {
        Defaults[DefaultsKeys.UserId] = id
    }
    
    // Check Text Fields
    fileprivate func checkForErrors() -> Bool {
        var errors = false
        let title = "Error"
        var message = ""
        
        if txtFullName.text!.isEmpty
        {
            errors = true
            message += "Full Name empty"
            showAlertWithTitle(title, message: message, toFocus:txtFullName)
        }
            //        else if !txtFullName.text!.isValidName()
            //        {
            //            errors = true
            //            message += "Invalid Full Name"
            //            showAlertWithTitle(title, message: message, toFocus:txtFullName)
            //        }
        else if txtEmail.text!.isEmpty
        {
            errors = true
            message += "Email empty"
            showAlertWithTitle(title, message: message, toFocus:txtEmail)
        }
        else if !txtEmail.text!.isValidEmail()
        {
            errors = true
            message += "Invalid Email Address"
            showAlertWithTitle(title, message: message, toFocus:txtEmail)
            
        }
        else if txtPassword.text!.isEmpty
        {
            errors = true
            message += "Password empty"
            showAlertWithTitle(title, message: message, toFocus:txtPassword)
        }
        else if !txtPassword.text!.isValidPassword()
        {
            errors = true
            message += "Password must be at least 8 characters"
            showAlertWithTitle(title, message: message, toFocus:txtPassword)
        }
        
        return errors
    }
}

extension CustomerSignupViewController {
    
    @IBAction func googleLoginButtonTapped(_ sender: AnyObject) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func facebookLoginButtonTapped(_ sender: AnyObject) {
        
        let loginManager = LoginManager()
        loginManager.loginBehavior = .native
        loginManager.logOut() //doing some clean up in its stored credentials
        UIApplication.shared.beginIgnoringInteractionEvents()
        loginManager.logIn([ .publicProfile, .email, .userFriends], viewController: self) { loginResult in
            
            switch loginResult {
            case .success:
                print ("fb login success")
                self.getUserProfileFromFacebook()
            case .failed(let error):
                UIApplication.shared.endIgnoringInteractionEvents()
                print(error)
            case .cancelled:
                UIApplication.shared.endIgnoringInteractionEvents()
                print("User cancelled login.")
            }
        }
    }
    
    @IBAction func whiteXButtonTapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func getUserProfileFromFacebook() {
        
        User.getFacebookProfile() { jsonProfile in
            
            guard let jsonProfile = jsonProfile else {
                UIApplication.shared.endIgnoringInteractionEvents()
                return
            }
            
            let email = jsonProfile["email"].stringValue
            let facebookID = jsonProfile["id"].stringValue
            let firstName = jsonProfile["first_name"].stringValue
            let lastName = jsonProfile["last_name"].stringValue
            let facebookToken = AccessToken.current!.authenticationToken
            let gender    = jsonProfile["gender"].stringValue
            let facebookProfilePhoto  = jsonProfile["picture"]["data"]["url"].stringValue
            
            if email.characters.count > 0 {
                
                User.signInWithFacebook(email: email, facebookID: facebookID, facebookToken: facebookToken, facebookProfilePhoto: facebookProfilePhoto, firstName: firstName, lastName: lastName, gender: gender) { (user, error, json) in
                    
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
                
            } else {
                
                UIApplication.shared.endIgnoringInteractionEvents()
                self.alertController = UIAlertController(title: "Email Required", message:"Input email associated to your Facebook Account.", preferredStyle: .alert)
                self.alertController?.addAction(UIAlertAction(title: "Done", style: .default, handler: {
                    alert -> Void in
                    
                    UIApplication.shared.beginIgnoringInteractionEvents()
                    let textField = (self.alertController?.textFields![0])! as UITextField
                    User.signInWithFacebook(email: textField.text!, facebookID: facebookID, facebookToken: facebookToken, facebookProfilePhoto: facebookProfilePhoto, firstName: firstName, lastName: lastName, gender: gender) { (user, error, json) in
                        UIApplication.shared.endIgnoringInteractionEvents()
                    }
                }))
                
                self.alertController?.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
                    textField.placeholder = "Email address"
                })
                
                DispatchQueue.main.async {
                    self.present(self.alertController!, animated: true, completion: nil)
                }
            }
        }
    }
    
    func promptForFullName() {
        showAlert("Error", message: "You must enter your full name.", ok: {})
    }
    
    @IBAction func btnDoneClicked(_ sender: UIButton) {
        
        if checkForErrors() { return }
        guard let fullNameArray = self.txtFullName.text?.components(separatedBy: " "), fullNameArray.count > 1 else { promptForFullName(); return }
        UIApplication.shared.beginIgnoringInteractionEvents()
        User.signup(email: self.txtEmail.text!, password: self.txtPassword.text!, firstName: fullNameArray[0], lastName: fullNameArray[1]) { (user, error, json) in
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if let err = json?["errors"], user == nil {
                
                var errorString = ""
                for (index,data) in err.enumerated() {
                    errorString = errorString + "\(data.0) " + data.1[index].stringValue + " "
                }
                self.showAlert("Error", message: errorString, ok: {})
                
            }
        }
        
    }
}

extension CustomerSignupViewController {
    
    @IBAction func txtValueChanged(_ sender: UITextField) {
        
        if txtFullName.text!.isEmpty || txtEmail.text!.isEmpty || txtPassword.text!.isEmpty {
            
            setDoneButtonDisable()
            
        } else {
            setDoneButtonEnable()
        }
    }
}
