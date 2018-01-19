//
//  NewMessageViewController.swift
//  Corner
//
//  Created by MobileGod on 24/01/2017.
//  Copyright © 2017 BSE. All rights reserved.
//

import UIKit
import Firebase
import DLRadioButton
import TPKeyboardAvoiding
import MapKit
class NewMessageViewController: AppViewController,CLLocationManagerDelegate {
    
    @IBOutlet weak var viewSpaceHeight1: NSLayoutConstraint!
    @IBOutlet weak var viewSpaceHeight2: NSLayoutConstraint!
    @IBOutlet weak var viewSpaceHeight3: NSLayoutConstraint!
    @IBOutlet weak var viewSpaceHeight4: NSLayoutConstraint!
    
    @IBOutlet weak var txtViewMessage: UITextView!
    
    @IBOutlet var scrollView: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var btnAddPhoto1:    UIButton!
    @IBOutlet weak var btnAddPhoto2:    UIButton!
    @IBOutlet weak var btnAddPhoto3:    UIButton!
    @IBOutlet weak var btnRemovePhoto1: UIButton!
    @IBOutlet weak var btnRemovePhoto2: UIButton!
    @IBOutlet weak var btnRemovePhoto3: UIButton!
    fileprivate var selBtnAddPhoto:        UIButton!
    
    var imagePath1: String = ""
    var imagePath2: String = ""
    var imagePath3: String = ""
    
    @IBOutlet weak var lblSelShopsCount: UILabel!
    
    @IBOutlet weak var radService: DLRadioButton!
    @IBOutlet weak var radPartsAndGear: DLRadioButton!
    @IBOutlet weak var radOther: DLRadioButton!
    
    @IBOutlet weak var btnPost: UIButton!
    
    public var shops1 =        DataManager.shared.shops
    public var shops =        [Shop]()
    public var shopsChecked = [Bool]()
    
    
    let locationManager = CLLocationManager()
    
    
    var array_selectedCell = [Bool]()
    
    
    
    fileprivate let placeholderText = "Type a message, and it will be sent to multiple shops around you in one easy step."
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        scrollView.keyboardDismissMode = .onDrag
        viewSpaceHeight1.constant = 0.5
        viewSpaceHeight2.constant = 0.5
        viewSpaceHeight3.constant = 0.5
        viewSpaceHeight4.constant = 0.5
        
        initAddPhotoButton(btnAddPhoto1)
        initAddPhotoButton(btnAddPhoto2)
        initAddPhotoButton(btnAddPhoto3)
        
        btnRemovePhoto1.isHidden = true
        btnRemovePhoto2.isHidden = true
        btnRemovePhoto3.isHidden = true
        
        txtViewMessage.delegate = self
        txtViewMessage.font = UIFont(name: "AvenirNext-Regular", size: 18.0)
        txtViewMessage.tintColor = Color.AppLightGreen
        txtViewMessage.becomeFirstResponder()
        initMessageWithPlaceHolder()
        
        if self.shops1.count <= 0 {
            self.shops1 = DataManager.shared.shops
        }
        
        shopsChecked = Array(repeating: false, count: shops1.count)
        
        
        
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }else
        {
            //            self.showAlert("", message: "Please enable your location service from setting.")
        }
        
        
        
        
        var distance : NSArray!
        
        
        if locationManager.location?.coordinate.latitude == nil
        {
            shops = shops1;
            //            self.showAlert("", message: "Please enable your location service from setting")
        }else
        {
            for SHOP in shops1
            {
                if SHOP.lat == ""
                {
                    return;
                }
                
                
                let coordinate₀ = CLLocation(latitude: Double(SHOP.lat)!, longitude: Double(SHOP.long)!)
                let coordinate₁ = CLLocation(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
                
                
                let distanceInMeters = coordinate₀.distance(from: coordinate₁) // result is in meters
                
//                                if distanceInMeters > 40233.6
//                                {
//
//                                }else
//                                {
                shops.append(SHOP)
                SHOP.distance = distanceInMeters
//                                }
            }
            
            
            
            let sortedArray=shops.sorted { (obj1, obj2) -> Bool in
                return obj1.distance < obj2.distance
            }
            print("sortedArray = \(sortedArray)")
            
            shops = sortedArray;

            for var i in 0..<sortedArray.count
            {
                if i == 6
                {
                    break
                }
                
                shopsChecked[i] = true;
                
                
            }
        }
        
        
        print(shops1)
        
        NotificationCenter.default.addObserver(self, selector: #selector(shopsLoaded(notif:)), name: .gotShops, object: nil)

        
    }
    
    func loadShop() {
        
        
        self.shops1 = DataManager.shared.shops
        shops.removeAll()

        var distance : NSArray!
        
        
        if locationManager.location?.coordinate.latitude == nil
        {
            shops = shops1;
            //            self.showAlert("", message: "Please enable your location service from setting")
        }else
        {
            for SHOP in shops1
            {
                if SHOP.lat == ""
                {
                    return;
                }
                
                
                let coordinate₀ = CLLocation(latitude: Double(SHOP.lat)!, longitude: Double(SHOP.long)!)
                let coordinate₁ = CLLocation(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
                
                
                let distanceInMeters = coordinate₀.distance(from: coordinate₁) // result is in meters
                
//                                if distanceInMeters > 40233.6
//                                {
//
//                                }else
//                                {
                shops.append(SHOP)
                SHOP.distance = distanceInMeters
//                                }
            }
            
            
            
            let sortedArray=shops.sorted { (obj1, obj2) -> Bool in
                return obj1.distance < obj2.distance
            }
            print("sortedArray = \(sortedArray)")
            
            shops = sortedArray;
            
            for var i in 0..<sortedArray.count
            {
                if i == 6
                {
                    break
                }
                
                shopsChecked[i] = true;
                
                
            }
        }
        self.updateSelShopsCount()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        if let contactShop = DataManager.shared.contactShop {
            
            shopsChecked = Array(repeating: false, count: shops.count)
            if let idx = self.shops.index(where: { $0.oid == contactShop.oid }) {
                
                self.shopsChecked[idx] = true
                DataManager.shared.contactShop = nil
                
            }
            
        }
        
        updateTitleView()
        updateSelShopsCount()
        updateBtnPost()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        var shouldIAllow = false
        var locationStatus : NSString = "Not Started"
        
        switch status {
        case CLAuthorizationStatus.restricted:
            locationStatus = "Restricted Access to location"
        case CLAuthorizationStatus.denied:
            locationStatus = "User denied access to location"
        case CLAuthorizationStatus.notDetermined:
            locationManager.requestWhenInUseAuthorization()
            shouldIAllow = true
        default:
            locationStatus = "Allowed to location Access"
            shouldIAllow = true
        }
        if (shouldIAllow == true) {
            NSLog("Location to Allowed")
            // Start location services
            locationManager.startUpdatingLocation()
            self.loadShop()

        } else {
            self.showAlert("", message: "Please enable your location service from setting")
        }
        
        
    }
    
    
    
    //this is to reload the shops content
    //in some case network is quite slow that it won't be able to fetch the data that fast.
    func shopsLoaded(notif:Notification) {
        
        self.shops1 = DataManager.shared.shops
        shops.removeAll()
        
        if locationManager.location?.coordinate.latitude == nil
        {
            shops = shops1;
            //            self.showAlert("", message: "Please enable your location service from setting")
        }else
        {
            for SHOP in shops1
            {
                if SHOP.lat == ""
                {
                    return;
                }
                
                
                let coordinate₀ = CLLocation(latitude: Double(SHOP.lat)!, longitude: Double(SHOP.long)!)
                let coordinate₁ = CLLocation(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
                
                
                let distanceInMeters = coordinate₀.distance(from: coordinate₁) // result is in meters
                
//                               if distanceInMeters > 40233.6
//                                {
//
//                                }else
//                                {
                shops.append(SHOP)
                SHOP.distance = distanceInMeters
//                                }
            }
            
            
            
            let sortedArray=shops.sorted { (obj1, obj2) -> Bool in
                return obj1.distance < obj2.distance
            }
            print("sortedArray = \(sortedArray)")
            shops = sortedArray;

            shopsChecked = Array(repeating: false, count: shops.count)
            
            for var i in 0..<sortedArray.count
            {
                if i == 6
                {
                    break
                }
                
                shopsChecked[i] = true;
                
                
            }
        }
        
        
        self.updateSelShopsCount()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "gotoSelShopsVC" {
            
            let desVC = segue.destination as! SelectShopsViewController
            desVC.shops = shops
            desVC.shopsChecked = shopsChecked
            desVC.newMessageVC = self
            
        }
    }
    
    fileprivate func resetContent() {
        
        self.txtViewMessage.text = "" //remove the textview content
        self.initMessageWithPlaceHolder()
        
        //remove all selected shops and reset the display count
        //        self.shopsChecked.removeAll()
        //        self.shopsChecked = Array(repeating: false, count: shops.count) // set selected shops to all
        self.updateSelShopsCount()
        
        //make radio buttons unselected
        for buttons in self.radOther.otherButtons {
            buttons.isSelected = false
        }
        
        //reset images
        self.initAddPhotoButton(btnAddPhoto1)
        self.initAddPhotoButton(btnAddPhoto2)
        self.initAddPhotoButton(btnAddPhoto3)
        self.btnRemovePhoto1.isHidden = true
        self.btnRemovePhoto2.isHidden = true
        self.btnRemovePhoto3.isHidden = true
        
        //update submit button UI
        self.updateBtnPost()
    }
    
    func uploadImage(imagePath: String, issueID: String, imageString: String) {
        
        let localFile = URL(string: imagePath)!
        let imageLocation = "/issues/\(issueID)/images/\(imageString).png"
        let imageRef = IssuesManager.shared.firebaseStorage.child(imageLocation)
        guard let user = DataManager.shared.currentUser else { return }
        let uploadTask = imageRef.putFile(from: localFile, metadata: nil) { metadata, error in
            
            if let metadata = metadata {
                let imageURL = metadata.downloadURL()
                let newIssue = ["/issues/\(issueID)/images/\(imageString)" : imageURL!.absoluteString] as [String : Any]
                
                IssuesManager.shared.firebaseReference.updateChildValues(newIssue, withCompletionBlock: { (error: Error?, ref: DatabaseReference!) in
                    NotificationCenter.default.post(name: .updateIssues, object: nil)
                    if error != nil {
                        print("error = \(String(describing: error?.localizedDescription))")
                    }
                })
                
                let newIssue2 = ["/users/\(user.oid)/issues/\(issueID)/images/\(imageString)" : imageURL!.absoluteString] as [String : Any]
                
                IssuesManager.shared.firebaseReference.updateChildValues(newIssue2, withCompletionBlock: { (error: Error?, ref: DatabaseReference!) in
                    NotificationCenter.default.post(name: .updateIssues, object: nil)
                    if error != nil {
                        print("error = \(String(describing: error?.localizedDescription))")
                    }
                })
                
            } else {
                print("firebase: error in image upload: \(error!.localizedDescription)")
            }
        }
        
        uploadTask.resume()
    }
    
}


//
// MARK: - Private Functions
///
///

extension NewMessageViewController {
    
    fileprivate func initMessageWithPlaceHolder() {
        
        txtViewMessage.text = placeholderText
        txtViewMessage.textColor = Color.darkGray
    }
    
    fileprivate func makeMessageStatusToWriting() {
        
        txtViewMessage.text = ""
        txtViewMessage.textColor = Color.black
    }
    
    fileprivate func updateTitleView() {
        
        if numSelShops == 1 {
            
            // Update NavigationBar Item Title
            let lblTitle = UILabel(frame: CGRect.init(x: 0, y: 0, width: 480, height: 44))
            lblTitle.backgroundColor = UIColor.clear
            lblTitle.font = UIFont.boldSystemFont(ofSize: 17.0)
            lblTitle.numberOfLines = 2
            lblTitle.textAlignment = .center
            
            let mutableString = NSMutableAttributedString(string: "New Message\n" + specificShop.name,
                                                          attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 17.0),
                                                                       NSForegroundColorAttributeName: Color.white])
            mutableString.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 10.0)],
                                        range: NSRange.init(location: 12, length: specificShop.name.characters.count))
            lblTitle.attributedText = mutableString
            lblTitle.sizeToFit()
            
            self.navigationController?.title = "NEW MESSAGE"
            self.navigationController?.navigationItem.titleView = lblTitle
            
            // Hide SelectShop
            
        } else {
            self.navigationController?.title = "NEW MESSAGE"
            self.navigationController?.navigationItem.titleView = nil
        }
    }
    
    fileprivate func updateSelShopsCount() {
        
        if numSelShops == 0 {
            lblSelShopsCount.text = "Not Selected"
        } else if numSelShops == 1 {
            lblSelShopsCount.text = specificShop.name
        } else if numSelShops == DataManager.shared.shops.count {
            lblSelShopsCount.text = "All"
        } else {
            lblSelShopsCount.text = numSelShops.description
        }
    }
    
    fileprivate var numSelShops: Int {
        return shopsChecked.filter{$0 == true}.count
    }
    
    fileprivate var specificShop: Shop {
        return shops[shopsChecked.index(of: (shopsChecked.filter{$0 == true}.first!))!]
    }
    
    fileprivate func updateBtnPost() {
        
        if txtViewMessage.text.isEmpty || self.txtViewMessage.text == self.placeholderText ||
            (btnAddPhoto1.image(for: .normal) != nil && btnAddPhoto1.image(for: .normal)! == #imageLiteral(resourceName: "AddPhoto") &&
                btnAddPhoto2.image(for: .normal) != nil && btnAddPhoto2.image(for: .normal)! == #imageLiteral(resourceName: "AddPhoto") &&
                btnAddPhoto3.image(for: .normal) != nil && btnAddPhoto3.image(for: .normal)! == #imageLiteral(resourceName: "AddPhoto")) ||
            lblSelShopsCount.text == "Not Selected" {
            
            btnPost.backgroundColor = UIColor.clear
            btnPost.setTitleColor(Color.AppOrange, for: .normal)
            btnPost.setRoundedBorder(cornerRadius: 3.0, borderWidth: 1.0, borderColor: Color.AppOrange)
            btnPost.isEnabled = false
            
        } else {
            
            btnPost.backgroundColor = Color.AppOrange
            btnPost.setTitleColor(UIColor.white, for: .normal)
            btnPost.setCornerRadius(cornerRadius: 3.0)
            btnPost.isEnabled = true
            
        }
    }
    
    fileprivate func openImagePicker(fromButton sender: UIButton) {
        
        selBtnAddPhoto = sender
        
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
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(cameraAction)
        alert.addAction(rollAction)
        
        present(alert, animated: true, completion: nil)
    }
}

extension NewMessageViewController {
    
    // Cancel Clicked
    @IBAction func btnCancelClicked(_ sender: UIBarButtonItem) {
        
        Log("Cancel Clicked")
        self.resetContent()
        tabBarController?.selectedIndex = 1
        
    }
    
    // Add Photo Clicked
    @IBAction func btnAddPhoto1Clicked(_ sender: UIButton) {
        Log("First AddPhoto Button Clicked")
        openImagePicker(fromButton: sender)
    }
    
    @IBAction func btnAddPhoto2Clicked(_ sender: UIButton) {
        Log("Second AddPhoto Button Clicked")
        openImagePicker(fromButton: sender)
    }
    
    @IBAction func btnAddPhoto3Clicked(_ sender: UIButton) {
        Log("Third AddPhoto Button Clicked")
        openImagePicker(fromButton: sender)
    }
    
    @IBAction func btnRemovePhoto1Clicked(_ sender: UIButton) {
        self.initAddPhotoButton(btnAddPhoto1)
        btnRemovePhoto1.isHidden = true
        self.updateBtnPost()
    }
    
    @IBAction func btnRemovePhoto2Clicked(_ sender: UIButton) {
        self.initAddPhotoButton(btnAddPhoto2)
        btnRemovePhoto2.isHidden = true
        self.updateBtnPost()
    }
    
    @IBAction func btnRemovePhoto3Clicked(_ sender: UIButton) {
        self.initAddPhotoButton(btnAddPhoto3)
        btnRemovePhoto3.isHidden = true
        self.updateBtnPost()
    }
    
    @IBAction func btnSelectShopsClicked(_ sender: UIButton) {
        Log("Select Shops Clicked")
    }
    
    @IBAction func btnPostClicked(_ sender: UIButton) {
        
        Log("Post Clicked")
        
        if txtViewMessage.text.characters.count > 0 {
            
            //pass an array of shops object if user choose a shop.
            //this will be taken from SelectShopsVC
            
            var shopsName = "";
            
            var shops = [Shop]()
            for (index,element) in self.shops.enumerated() {
                Log("\(index)")
                
                if self.shopsChecked[index] == true {
                    
                    if (element.employee.oid == "")
                    {
                        
                        Log("➣ ➣ null ids \(element.name) -> \(element.employee.oid)")

                        
                        shopsName = shopsName + element.name + ", "
                    }else
                    {
                        Log("➣ ➣ having ids \(element.name) -> \(element.employee.oid)")

                        shops.append(element)
                    }
                }
            }
            
            var truncated = "";
            
            if shopsName == ""
            {
                
            }else
            {
                let endIndex = shopsName.index(shopsName.endIndex, offsetBy: -2)
                 truncated = shopsName.substring(to: endIndex)
            }
            
            
            
            
            var issueID = ""
            if shops.count < 0 {
                issueID = Issue.create(message: txtViewMessage.text, shops: nil)
            } else {
                issueID = Issue.create(message: txtViewMessage.text, shops: shops)
            }
            
            if imagePath1 != "" {
                uploadImage(imagePath: imagePath1, issueID: issueID, imageString: "image1")
            }
            if imagePath2 != "" {
                uploadImage(imagePath: imagePath2, issueID: issueID, imageString: "image2")
            }
            if imagePath3 != "" {
                uploadImage(imagePath: imagePath3, issueID: issueID, imageString: "image3")
            }
            
            var messageTitle = ""
            if shops.count == 1 {
                messageTitle = "Message sent to " + shops[0].name + "!"
            } else if shops.count > 1 {
                messageTitle = "Message sent to \(shops.count) shops!"
            }
            
            if (truncated == "")
            {
                
            }else
            {
                messageTitle = messageTitle + "Recipient not configured for " + truncated
            }
            
            
            
            //            + "Recipient not configured for " + truncated
            self.view.endEditing(true)
            showAlert(messageTitle, message: "", ok: { [weak self] in
                self?.resetContent()
            })
            
        }
        
        NotificationCenter.default.post(name: .updateIssues, object: nil)
        
        
    }
}

extension NewMessageViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        updateBtnPost()
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        if txtViewMessage.text == placeholderText {
            
            makeMessageStatusToWriting()
        }
        
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if txtViewMessage.text == "" {
            initMessageWithPlaceHolder()
        }
    }
}

extension NewMessageViewController: UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        Log("Cancelled")
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let selectedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        setImageAddPhotoButton(for: selBtnAddPhoto, selImage: selectedImage)
        switch selBtnAddPhoto {
        case btnAddPhoto1:
            let localPath = self.saveImageDocumentDirectory(image: selectedImage, number: "1")
            imagePath1 = "file://\(localPath)"
            btnRemovePhoto1.isHidden = false
            break
        case btnAddPhoto2:
            let localPath = self.saveImageDocumentDirectory(image: selectedImage, number: "2")
            imagePath2 = "file://\(localPath)"
            btnRemovePhoto2.isHidden = false
            break
        case btnAddPhoto3:
            let localPath = self.saveImageDocumentDirectory(image: selectedImage, number: "3")
            imagePath3 = "file://\(localPath)"
            btnRemovePhoto3.isHidden = false
            break
        default:
            break
        }
        updateBtnPost()
        
        dismiss(animated: true, completion: nil)
    }
    
    func saveImageDocumentDirectory(image: UIImage, number: String) -> String{
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("image\(number).jpg")
        let imageData = UIImageJPEGRepresentation(image, 0.8)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
        return paths
    }
    
}


