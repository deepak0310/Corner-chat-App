//
//  LogInViewController.swift
//  Corner
//
//  Created by MobileGod on 27/01/2017.
//  Copyright © 2017 BSE. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Material

class LoginViewController: UIViewController, UIApplicationDelegate {
	
	// MARK: - Properties
	private let leftTextField:		CGFloat = 30
	private let heightTextField:	CGFloat = 60.0
	private let bottomViewInput:	CGFloat = 20.0
	private let topViewInput:		CGFloat = 10.0
	
	@IBOutlet weak var widthSignInBtn:	NSLayoutConstraint!
	@IBOutlet weak var widthJoinNowBtn: NSLayoutConstraint!
	private var muted: Bool = true
	let FONT_BTN =	UIFont(name: "Avenir Book", size: 15)
	let FONT_TEXT = UIFont(name: "Avenir Book", size: 14)
	
	// MARK: - Controllers
	internal var window: UIWindow?
	@IBOutlet weak var scrollView:	UIScrollView!
	@IBOutlet weak var btnSignIn:	UIButton!
	@IBOutlet weak var viewSignIn:	UIView!
	@IBOutlet weak var btnLogo:		UIButton!
	private var txtUsername_SignIn: TextField!
	private var txtPassword_SignIn: TextField!
	
	@IBOutlet weak var viewSignUp:	UIView!
	@IBOutlet weak var btnJoinNow:	UIButton!
	private var txtUsername_Join:	TextField!
	private var txtEmail_Join:	TextField!
	private var txtPassword_Join:	TextField!
	private var txtPhone_Join:		TextField!
	private var txtBirthDate_Join:	TextField!
	private var txtSex_Join:		TextField!
	
	@IBOutlet weak var viewVideo: UIView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		self.scrollView.delaysContentTouches = false
		
		let tapRecog = UITapGestureRecognizer(target: self, action: #selector(self.TapOnView))
		self.view.addGestureRecognizer(tapRecog)
		
		InitBackgroundVideo()
		InitSignInBtn()
		InitJoinNowBtn()
		prepareNameField_SignIn()
		preparePasswordField_SignIn()
		prepareNameField_Join()
		prepareEmailField_Join()
		preparePasswordField_Join()
		preparePhoneField_Join()
		prepareBirthDayField_Join()
		prepareSexField_Join()
	}
	override func viewDidDisappear(_ animated: Bool) {
		
		AppDelegate.player = nil
		NotificationCenter.default.removeObserver(self)
	}
	
	override var prefersStatusBarHidden: Bool {
		
		return true
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	// MARK: - Private Functions
	
	@objc private func TapOnView() {
		
		self.view.endEditing(true)
	}
	
	private func InitSignInBtn() {
		
		widthSignInBtn.constant = UIScreen.main.bounds.size.width - leftTextField * 2
		btnSignIn.setTitle("Sign In", for: .normal)
		btnSignIn.backgroundColor = Color.AppBlue
		btnSignIn.setCornerRadius(cornerRadius: 25.0)
	}
	
	
	private func prepareNameField_SignIn() {
		
		txtUsername_SignIn = TextField()
		txtUsername_SignIn.textColor = Color.white
		txtUsername_SignIn.placeholder = "Username"
		txtUsername_SignIn.placeholderNormalColor = Color.lightGray
		txtUsername_SignIn.isClearIconButtonEnabled = true
		txtUsername_SignIn.dividerNormalColor = Color.lightGray
		
		let leftView = UIImageView()
		leftView.image = Icons.USER
		
		txtUsername_SignIn.leftView = leftView
		txtUsername_SignIn.leftViewMode = .always
		
		viewSignIn.layout(txtUsername_SignIn).top(viewSignIn.frame.size.height - heightTextField * 2 + bottomViewInput).horizontally(left: leftTextField, right: leftTextField)
	}
	
	private func preparePasswordField_SignIn() {
		
		txtPassword_SignIn = TextField()
		txtPassword_SignIn.textColor = Color.white
		txtPassword_SignIn.placeholder = "Password"
		txtPassword_SignIn.placeholderNormalColor = Color.lightGray
		txtPassword_SignIn.dividerNormalColor = Color.lightGray
		
		let leftView = UIImageView()
		leftView.image = Icons.PASSWORD
		
		txtPassword_SignIn.leftView = leftView
		txtPassword_SignIn.leftViewMode = .always
		
		txtPassword_SignIn.detailColor = Color.lightGray
		txtPassword_SignIn.clearButtonMode = .whileEditing
		txtPassword_SignIn.isVisibilityIconButtonEnabled = true
		
		// Setting the visibilityIconButton color.
		txtPassword_SignIn.visibilityIconButton?.tintColor = Color.green.base.withAlphaComponent(txtPassword_SignIn.isSecureTextEntry ? 0.38 : 0.54)
		
		viewSignIn.layout(txtPassword_SignIn).top(viewSignIn.frame.size.height - heightTextField + bottomViewInput).horizontally(left: leftTextField, right: leftTextField)
	}
	
	private func InitJoinNowBtn() {
		
		widthJoinNowBtn.constant = UIScreen.main.bounds.size.width - leftTextField * 2
		btnJoinNow.setTitle("Join Now", for: .normal)
		btnJoinNow.backgroundColor = Color.AppBlue
		btnJoinNow.titleLabel?.font = FONT_BTN
		btnJoinNow.setCornerRadius(cornerRadius: 25.0)
	}
	
	
	/// Join View
	private func prepareNameField_Join() {
		
		txtUsername_Join = TextField()
		txtUsername_Join.textColor = Color.white
		txtUsername_Join.placeholder = "Full Name"
		txtUsername_Join.placeholderNormalColor = Color.lightGray
		txtUsername_Join.isClearIconButtonEnabled = true
		txtUsername_Join.dividerNormalColor = Color.lightGray
		txtUsername_Join.font = FONT_TEXT
		
		let leftView = UIImageView()
		leftView.image = Icons.USER
		
		txtUsername_Join.leftView = leftView
		txtUsername_Join.leftViewMode = .always
		
		viewSignUp.layout(txtUsername_Join).top(heightTextField - topViewInput).horizontally(left: leftTextField, right: leftTextField)
	}
	
	private func prepareEmailField_Join() {
		
		txtEmail_Join = TextField()
		txtEmail_Join.textColor = Color.white
		txtEmail_Join.placeholder = "Email"
		txtEmail_Join.placeholderNormalColor = Color.lightGray
		txtEmail_Join.isClearIconButtonEnabled = true
		txtEmail_Join.dividerNormalColor = Color.lightGray
		txtEmail_Join.font = FONT_TEXT
		
		let leftView = UIImageView()
		leftView.image = Icons.EMAIL
		
		txtEmail_Join.leftView = leftView
		txtEmail_Join.leftViewMode = .always
		
		viewSignUp.layout(txtEmail_Join).top(heightTextField * 2 - topViewInput).horizontally(left: leftTextField, right: leftTextField)
	}
	
	private func preparePasswordField_Join() {
		
		txtPassword_Join = TextField()
		txtPassword_Join.textColor = Color.white
		txtPassword_Join.placeholder = "Password"
		txtPassword_Join.placeholderNormalColor = Color.lightGray
		txtPassword_Join.dividerNormalColor = Color.lightGray
		txtPassword_Join.font = FONT_TEXT
		
		let leftView = UIImageView()
		leftView.image = Icons.PASSWORD
		
		txtPassword_Join.leftView = leftView
		txtPassword_Join.leftViewMode = .always
		
		txtPassword_Join.detailColor = Color.lightGray
		txtPassword_Join.clearButtonMode = .whileEditing
		txtPassword_Join.isVisibilityIconButtonEnabled = true
		
		// Setting the visibilityIconButton color.
		txtPassword_Join.visibilityIconButton?.tintColor = Color.green.base.withAlphaComponent(txtPassword_Join.isSecureTextEntry ? 0.38 : 0.54)
		
		viewSignUp.layout(txtPassword_Join).top(heightTextField * 3 - topViewInput).horizontally(left: leftTextField, right: leftTextField)
	}
	
	private func preparePhoneField_Join() {
		
		txtPhone_Join = TextField()
		txtPhone_Join.textColor = Color.white
		txtPhone_Join.placeholder = "Phone"
		txtPhone_Join.placeholderNormalColor = Color.lightGray
		txtPhone_Join.isClearIconButtonEnabled = true
		txtPhone_Join.dividerNormalColor = Color.lightGray
		txtPhone_Join.font = FONT_TEXT
		
		let leftView = UIImageView()
		leftView.image = Icons.PHONE
		
		txtPhone_Join.leftView = leftView
		txtPhone_Join.leftViewMode = .always
		
		viewSignUp.layout(txtPhone_Join).top(heightTextField * 4 - topViewInput).horizontally(left: leftTextField, right: leftTextField)
	}
	
	private func prepareBirthDayField_Join() {
		
		txtBirthDate_Join = TextField()
		txtBirthDate_Join.textColor = Color.white
		txtBirthDate_Join.placeholder = "Birth Date"
		txtBirthDate_Join.placeholderNormalColor = Color.lightGray
		txtBirthDate_Join.isClearIconButtonEnabled = true
		txtBirthDate_Join.dividerNormalColor = Color.lightGray
		txtBirthDate_Join.font = FONT_TEXT
		
		let leftView = UIImageView()
		leftView.image = Icons.BIRTHDATE
		
		txtBirthDate_Join.leftView = leftView
		txtBirthDate_Join.leftViewMode = .always
		
		viewSignUp.layout(txtBirthDate_Join).top(heightTextField * 5 - topViewInput).horizontally(left: leftTextField, right: leftTextField)
	}
	
	private func prepareSexField_Join() {
		
		txtSex_Join = TextField()
		txtSex_Join.textColor = Color.white
		txtSex_Join.placeholder = "Sex"
		txtSex_Join.placeholderNormalColor = Color.lightGray
		txtSex_Join.isClearIconButtonEnabled = true
		txtSex_Join.dividerNormalColor = Color.lightGray
		txtSex_Join.font = FONT_TEXT
		
		let leftView = UIImageView()
		leftView.image = Icons.SEX
		
		txtSex_Join.leftView = leftView
		txtSex_Join.leftViewMode = .always
		
		viewSignUp.layout(txtSex_Join).top(heightTextField * 6 - topViewInput).horizontally(left: leftTextField, right: leftTextField)
	}
	
	private func InitBackgroundVideo() {
		
		// Init Video View
		guard let path = Bundle.main.path(forResource: "Background", ofType: ".mp4")	else {
			print("Cannot find the video")
			return
		}
		
		AppDelegate.player = AVPlayer(url: URL(fileURLWithPath: path))
		let playerController = AVPlayerViewController()
		
		playerController.player = AppDelegate.player
		self.addChildViewController(playerController)
		self.viewVideo.addSubview(playerController.view)
		playerController.view.frame = self.viewVideo.frame
		playerController.showsPlaybackControls = false
		playerController.view.isUserInteractionEnabled = false
		AppDelegate.player?.play()
		
		AppDelegate.player?.actionAtItemEnd = AVPlayerActionAtItemEnd.none
		
		// AVPlayer Notification
		NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReached(notication:)),
		                                       name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
		                                       object: AppDelegate.player?.currentItem)
		audioSwitch(muted: muted)
	}
	
	// MARK: - AVPlayer Notification
	func playerItemDidReached(notication: Notification) {
		
		let playerItem = notication.object as! AVPlayerItem
		playerItem.seek(to: kCMTimeZero)
	}
	
	@IBAction func btnLogoClicked(_ sender: UIButton) {
		
		muted = !muted
		audioSwitch(muted: muted)
	}
	
	private func audioSwitch(muted: Bool) {
		
		AppDelegate.player?.isMuted = muted
	}
	
	@IBAction func btnSignInClicked(_ sender: UIButton) {
		
		Log("Signin Clicked")
		
		// Update Title
		UIView.setAnimationsEnabled(false)
		self.btnSignIn.setTitle("", for: .normal)
		UIView.setAnimationsEnabled(true)
		
		// Update Width
		self.widthSignInBtn.constant = 50
		var newRect = self.btnSignIn.frame
		let center = self.btnSignIn.center
		newRect.size.width = 50
		newRect.origin.x = center.x - 25
		
		// Add Indicator
		LoadingIndicatorView.show(indicatorPoint: btnSignIn.center)
		
		// Make Animation
		UIView.animate(withDuration: 0.25,
		               animations: {
						
						self.view.layoutIfNeeded()
		}, completion: {completed in
			
			self.makeButtonAnimation(button: self.btnSignIn)
		})
	}
	
	@IBAction func btnSignUpClicked(_ sender: UIButton) {
		
		Log("Signup Clicked")
		
		InitJoinNowBtn()
		let newPoint = CGPoint(x: UIScreen.main.bounds.size.width, y: 0)
		self.scrollView.setContentOffset(newPoint, animated: true)
	}
	
	
	// MARK: ---------- Join Page
	@IBAction func btnJoinNowClicked(_ sender: UIButton) {
		
		// Update Title
		UIView.setAnimationsEnabled(false)
		self.btnJoinNow.setTitle("", for: .normal)
		UIView.setAnimationsEnabled(true)
		
		// Update Width
		self.widthJoinNowBtn.constant = 50
		var newRect = self.btnJoinNow.frame
		let center = self.btnJoinNow.center
		newRect.size.width = 50
		newRect.origin.x = center.x - 25
		
		// Add Indicator
		LoadingIndicatorView.show(indicatorPoint: self.btnJoinNow.center)
		
		// Make Animation
		UIView.animate(withDuration: 0.5,
		               animations: {
						
						self.view.layoutIfNeeded()
		}, completion: {completed in
			
			self.makeButtonAnimation(button: self.btnJoinNow)
		})
	}
	
	// MARK: - Back Button Clicked
	@IBAction func btnBackClicked(_ sender: AnyObject) {
		Log("Back Clicked")
		InitSignInBtn()
		self.scrollView.setContentOffset(CGPoint.zero, animated: true)
	}
	
	fileprivate func makeButtonAnimation(button: UIButton) {
		
		DispatchQueue.main.after(3.0, execute: {
			
			LoadingIndicatorView.hide()
			
			UIView.animate(withDuration: 0.0,
			               delay: 0.2,
			               options: [],
			               animations: {
							
							let vc = RoleSelectionViewController(nibName: "RoleSelectionViewController", bundle: nil)
							self.present(vc, animated: true, completion: nil)
			}, completion: nil)
			
			button.superview!.bringSubview(toFront: button)
			let scale = CGFloat(sqrtf(powf(Float(button.center.x), 2) + powf(Float(button.center.y), 2))) / button.frame.size.height * 2
			button.shadowRadius = 2.0
			UIView.animate(withDuration: 0.3,
			               delay: 0.0,
			               options: [UIViewAnimationOptions.curveLinear],
			               animations: {
							
							button.transform = CGAffineTransform(scaleX: scale, y: scale)
			}, completion: {(finished: Bool) in
				
				//				DispatchQueue.main.async(execute: {
				//					UIApplication.shared.keyWindow?.rootViewController = self.slideMenuController
				//				})
				//				UIApplication.shared.keyWindow?.rootViewController = self.slideMenuController
				//				UIApplication.shared.keyWindow?.makeKeyAndVisible()
			})
		})
	}
}



// MARK: - TextField Delegate
extension LoginViewController: TextFieldDelegate {
	
	public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		return true
	}
	
	public func textFieldDidBeginEditing(_ textField: UITextField) {
	}
	
	public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		return true
	}
	
	public func textFieldDidEndEditing(_ textField: UITextField) {
		(textField as? ErrorTextField)?.isErrorRevealed = false
	}
	
	public func textFieldShouldClear(_ textField: UITextField) -> Bool {
		(textField as? ErrorTextField)?.isErrorRevealed = false
		return true
	}
	
	public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		(textField as? ErrorTextField)?.isErrorRevealed = false
		return true
	}
	
	public func textField(textField: UITextField, didChange text: String?) {
		print("did change", text ?? "")
	}
	
	public func textField(textField: UITextField, willClear text: String?) {
		print("will clear", text ?? "")
	}
	
	public func textField(textField: UITextField, didClear text: String?) {
		print("did clear", text ?? "")
	}
}
