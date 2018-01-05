//
//  AppDelegate.swift
//  Corner
//
//  Created by MobileGod on 24/01/2017.
//  Copyright © 2017 BSE. All rights reserved.
//

import UIKit
import AVFoundation
import AlamofireNetworkActivityIndicator
import FacebookCore
import FacebookLogin
import FBSDKCoreKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import GoogleSignIn
import Fabric
import Crashlytics
import UserNotifications
import SwiftyJSON
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    var window: UIWindow?
    static var player: AVPlayer?
    var ref: DatabaseReference?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        registerForNotifications()
        
        NetworkActivityIndicatorManager.shared.isEnabled = true
        NetworkActivityIndicatorManager.shared.startDelay = 0.1
        application.statusBarStyle = .lightContent
        Messaging.messaging().delegate = self as? MessagingDelegate
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = false
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        Fabric.with([Crashlytics.self])
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let shouldForceLogout = UserDefaults.standard.bool(forKey: Prefs.shouldForceLogoutKey)
        
        if shouldForceLogout {
            User.forceLogout()
        }
        
        Messaging.messaging().shouldEstablishDirectChannel = true
        
        if APIManager.keychain[Prefs.tokenKey] != nil {
            
            User.refreshAuthTokens() { (user, error, json) in
                
                if let user = user {
                    user.saveCredentialsToKeychain()
                    IssuesManager.shared.listenForMessages(uid: user.oid)
                    self.configureFirebase()
                }
            }
            
            
            if APIManager.keychain[Prefs.roleKey] == "customer" {
                
                let storyboard = UIStoryboard(name: "Customer", bundle: nil)
                let navVC = storyboard.instantiateViewController(withIdentifier: "CustomerNavigationViewController")
                self.window?.rootViewController = navVC
                
            } else {
                
                let storyboard = UIStoryboard(name: "Shop", bundle: nil)
                let navVC = storyboard.instantiateViewController(withIdentifier: "StoreNavigationViewController")
                self.window?.rootViewController = navVC
                
            }
            
        } else {
            
            print("not logged in")
            
            let vc = RoleSelectionViewController(nibName: "RoleSelectionViewController", bundle: nil)
            self.window?.rootViewController = vc
        }
        
        let token = Messaging.messaging().fcmToken ?? ""
        print("FCM token: \(token)")
        if token != "" {
            updateUserNotificationTokenOnServer()
        }
        
        self.window?.makeKeyAndVisible()
        
        application.applicationIconBadgeNumber = 0
        
        return SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let googleDidHandle = GIDSignIn.sharedInstance().handle(url,
                                                                sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                                annotation: [:])
        
        let facebookDidHandle = SDKApplicationDelegate.shared.application(app, open: url, options: options)
        
        return googleDidHandle || facebookDidHandle
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        AppDelegate.player?.pause()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        AppDelegate.player?.play()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
        AppEventsLogger.activate(application)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var token = ""
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        print("Registration succeeded! Token: ", token)
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func registerForNotifications() {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { [weak self] (_, _) in
                    guard let strongSelf = self else { return }
                    strongSelf.updateUserNotificationTokenOnServer()
            })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
        UIApplication.shared.registerForRemoteNotifications()
        
    }
    
    func updateUserNotificationTokenOnServer() {
        guard let user = DataManager.shared.currentUser else { return }
        guard IssuesManager.shared.firebaseReference != nil else { return }
        let token = Messaging.messaging().fcmToken ?? ""
        var ref = "/users/\(user.oid)/"
        if let shopOid = user.shop?.oid, shopOid != "" {
            ref = "/users/\(shopOid)/"
        }
        if token != "" {
            IssuesManager.shared.firebaseReference.child(ref).updateChildValues(["token": token])
            
        }
        print("updated token at \(ref)")
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        updateUserNotificationTokenOnServer()
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        updateUserNotificationTokenOnServer()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("failed to register for notifications :(")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // Print message ID.
        //        if let messageID = userInfo[MessageIDKey] {
        //            print("Message ID: \(messageID)")
        //        }
        
        // Print full message.
        let json = JSON(userInfo)
        let message = json["aps"]["alert"].stringValue
        print(message)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // Print message ID.
        //        if let messageID = userInfo[gcmMessageIDKey] {
        //            print("Message ID: \(messageID)")
        //        }
        
        let json = JSON(userInfo)
        let message = json["aps"]["alert"].stringValue
        print(message)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        // Let FCM know about the message for analytics etc.
        Messaging.messaging().appDidReceiveMessage(userInfo)
        // handle your message
    }
    
    // Firebase notification received
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
        
        print("Handle push from foreground\(notification.request.content.userInfo)")
        
        let dict = notification.request.content.userInfo["aps"] as! NSDictionary
        let d : [String : Any] = dict["alert"] as! [String : Any]
        let body : String = d["body"] as! String
        let title : String = d["title"] as! String
        print("Title:\(title) + body:\(body)")
        self.showAlertAppDelegate(title: title,message:body,buttonTitle:"ok",window:self.window!)
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Handle push from background or closed\(response.notification.request.content.userInfo)")
    }
    
    func showAlertAppDelegate(title: String,message : String,buttonTitle: String,window: UIWindow){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.default, handler: nil))
        window.rootViewController?.present(alert, animated: false, completion: nil)
    }
    // Firebase ended here
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")
        
    }
    
    
}

extension AppDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        
        if let error = error {
            
            print ("google signin error \(error.localizedDescription)")
            UIApplication.shared.endIgnoringInteractionEvents()
            return
        }
        
        if user.authentication != nil {
            
            User.signInWithGoogle(email: user!.profile.email!, googleID: user!.userID!, googleProfilePhoto: user!.profile.imageURL(withDimension: 200).absoluteString, firstName: user!.profile.givenName!, lastName: user!.profile.familyName!) { (user, error, json) in
                
                UIApplication.shared.endIgnoringInteractionEvents()
                if user != nil {
                    print("user is logged in via google")
                }
            }
            
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print ("google did disconnect. what to do?")
    }
}


extension AppDelegate {
    
    @objc func configureFirebase() {
        
        if Auth.auth().currentUser == nil {
            
            if let firebaseToken = APIManager.keychain[Prefs.firebaseTokenKey] {
                
                Auth.auth().signIn(withCustomToken: firebaseToken, completion: { (user, error) in
                    
                    if let user = user {
                        
                        let token = Messaging.messaging().fcmToken ?? ""
                        if token != "" {
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.updateUserNotificationTokenOnServer()
                        }
                        
                        Database.database().reference().child("users/\(user.uid)/full_name")
                            .setValue(APIManager.keychain[Prefs.fullNameKey]!)
                        
                        print("Firebase: authenticated")
                        _ = IssuesManager.shared
                    }
                    
                    if let error = error {
                        print("Firebase: error \(error). Refreshing Token via API")
                        
                        User.refreshAuthTokens() { (user, error, json) in
                            
                            if let user = user {
                                user.saveCredentialsToKeychain()
//                                self.configureFirebase()
                            }
                        }
                    }
                })
            }
            
        } else {
            print("Firebase: still has authenticated session")
            let token = Messaging.messaging().fcmToken ?? ""
            if token != "" {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.updateUserNotificationTokenOnServer()
            }
            
            _ = IssuesManager.shared
        }
    }
}

extension Data {
    func hexString() -> String? {
        let buffer = (self as NSData).bytes.bindMemory(to: UInt8.self, capacity: self.count)
        
        var hexadecimalString = ""
        for i in 0..<self.count {
            hexadecimalString += String(format: "%02x", buffer.advanced(by: i).pointee)
        }
        
        if hexadecimalString.characters.count > 0 {
            return hexadecimalString
        }
        
        return nil
    }
}

