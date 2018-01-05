//
//  StoreSettingEditViewController.swift
//  Corner
//
//  Created by MobileGod on 31/01/2017.
//  Copyright © 2017 BSE. All rights reserved.
//

import UIKit

class StoreSettingEditViewController: UIViewController {

	@IBOutlet weak var btnAddPhoto: UIButton!
	@IBOutlet weak var btnDone: UIButton!
	@IBOutlet weak var txtShopName: UITextField!
	@IBOutlet weak var txtAddress1: UITextField!
	@IBOutlet weak var txtAddress2: UITextField!
	@IBOutlet weak var txtPhoneNum: UITextField!
	
	fileprivate let bgColor = UIColor(red: 199, green: 199, blue: 205)
	fileprivate let btnDoneBGColor = UIColor(red: 220, green: 220, blue: 220)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		view.backgroundColor = bgColor
		
		initAddPhotoButton(btnAddPhoto)
		
		btnDone.setCornerRadius(cornerRadius: 3.0)
		setDoneButtonDisable()
	}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        btnAddPhoto.isHidden = true
    }
	
}

//
// MARK: - Private Functions
///
///

extension StoreSettingEditViewController {
	
	fileprivate func setDoneButtonEnable() {
		
		btnDone.setTitleColor(UIColor.white, for: .normal)
		btnDone.backgroundColor = Color.AppBlue
		btnDone.isEnabled = true
	}
	
	fileprivate func setDoneButtonDisable() {
		
		btnDone.setTitleColor(UIColor.lightGray, for: .normal)
		btnDone.backgroundColor = btnDoneBGColor
		btnDone.isEnabled = false
	}
}


//
// MARK: - Button Click Events
///
///

extension StoreSettingEditViewController {

	@IBAction func btnBackClicked(_ sender: UIBarButtonItem) {
	
		_ = navigationController?.popViewController(animated: true)
	}
	
	@IBAction func btnAddPhotoClicked(_ sender: UIButton) {
		
		let imagePicker = UIImagePickerController()
		imagePicker.delegate = self
		imagePicker.allowsEditing = true
		
		let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		let cameraAction = UIAlertAction(title: "Take photo", style: .default) { (action) in
			
			imagePicker.sourceType = .camera
			self.present(imagePicker, animated: true, completion: nil)
		}
		let rollAction = UIAlertAction(title: "Camera roll", style: .default) { (action) in
			
			imagePicker.sourceType = .photoLibrary
			self.present(imagePicker, animated: true, completion: nil)
		}
		
		alert.addAction(cameraAction)
		alert.addAction(rollAction)
		
		if sender.image(for: .normal) != #imageLiteral(resourceName: "AddPhoto") {
			
			let removeAction = UIAlertAction(title: "Remove Photo", style: .destructive) { (action) in
				
				self.initAddPhotoButton(self.btnAddPhoto)
			}
			alert.addAction(removeAction)
		}
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		alert.addAction(cancelAction)
		present(alert, animated: true, completion: nil)
	}
	
	@IBAction func btnDoneClicked(_ sender: UIButton) {
		Log("Done Clicked")
        guard let user = DataManager.shared.currentUser else { return }
        guard let shopOid = user.shop?.oid else { return }
        let message: [String: String] = ["shop_name": txtShopName.text!, "address1": txtAddress1.text!, "address2": txtAddress2.text!, "phone": txtPhoneNum.text!]
        IssuesManager.shared.firebaseReference.child("/users/\(shopOid)/").updateChildValues(message)
        print("saving to /users/\(shopOid)/")
        performSegue(withIdentifier: "unwindToSettingsSegue", sender: self)
	}
}




//
// MARK: - UITextFieldDelegate
///
///

extension StoreSettingEditViewController {
	
	
	@IBAction func txtFieldValueDidChange(_ sender: UITextField) {
	
		if	txtShopName.text!.isEmpty || txtAddress1.text!.isEmpty ||
			txtAddress2.text!.isEmpty || txtPhoneNum.text!.isEmpty {
			
			setDoneButtonDisable()
			
		} else {
			setDoneButtonEnable()
		}
	}
}


//
// MARK: - ImagePickerController Delegates
///
///

extension StoreSettingEditViewController: UIImagePickerControllerDelegate {
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		Log("Cancelled")
		dismiss(animated: true, completion: nil)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            setImageAddPhotoButton(for: btnAddPhoto, selImage: selectedImage)
            dismiss(animated: true, completion: nil)
        } else {
            print("There was a problem displaying the image")
        }
	}
}
