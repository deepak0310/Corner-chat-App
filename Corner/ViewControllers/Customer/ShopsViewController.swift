//
//  ShopsViewController.swift
//  Corner
//
//  Created by MobileGod on 24/01/2017.
//  Copyright © 2017 BSE. All rights reserved.
//

import UIKit
import MapKit

class ShopsViewController: AppViewController,CLLocationManagerDelegate {
    
    @IBOutlet weak var tableView:        UITableView!
    @IBOutlet weak var segCtrl:            UISegmentedControl!
    @IBOutlet weak var viewSpaceHeight: NSLayoutConstraint!
    
    fileprivate var shops = [Shop]()
    let locationManager = CLLocationManager()
    
    fileprivate var filteredShops = [Shop]()
    
    fileprivate let reuseIdOfCell = "ShopTableViewCell"
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        segCtrl.tintColor = Color.AppGreen
        
        viewSpaceHeight.constant = 0.5
        
        let nib = UINib(nibName: "ShopTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: reuseIdOfCell)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.separatorColor = UIColor.white
        
        loadAllShops()
        
        self.tableView.isHidden = false
        self.mapView.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadShops(notif:)), name: .gotShops, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ShopsViewController {
    
    @objc fileprivate func reloadShops(notif: Notification) {
        loadAllShops()
    }
    
    fileprivate func loadAllShops() {
        
        shops = DataManager.shared.shops
        filteredShops = shops
        
        
        
        for SHOP in shops
        {
            
            let annotation = MKPointAnnotation()
            
            if SHOP.lat == ""
            {
                
            }else
            {
                annotation.coordinate = CLLocationCoordinate2D(latitude: Double(SHOP.lat)!, longitude: Double(SHOP.long)!)
                annotation.title = SHOP.name
                mapView.addAnnotation(annotation)
            }
            
            
            
            
        }
        
        print(locationManager.location?.coordinate.longitude)
        
        
        
        
        
        
        tableView.reloadData()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var locValue:CLLocationCoordinate2D = manager.location!.coordinate
        let center = CLLocationCoordinate2D(latitude: (manager.location!.coordinate.latitude), longitude: (manager.location!.coordinate.longitude))
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        
        self.mapView.setRegion(region, animated: true)
        
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    
    fileprivate func loadFavoriteShops() {
        
        filteredShops = DataManager.shared.shops.filter { $0.favorited }
        tableView.reloadData()
    }
    
    fileprivate func loadBlockedShops() {
        
        filteredShops = DataManager.shared.shops.filter { $0.blocked }
        tableView.reloadData()
    }
    
    fileprivate func configCell(indexPath: IndexPath) -> ShopTableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdOfCell, for: indexPath) as! ShopTableViewCell
        let shop = filteredShops[indexPath.row]
        cell.nameLabel.text = shop.name
        cell.streetLabel.text = shop.street
        cell.cityLabel.text = shop.city
        cell.favedImage.image = shop.favorited ? #imageLiteral(resourceName: "icn_shopslist_favorite_active") : #imageLiteral(resourceName: "icn_shopslist_favorite_inactive")
        //        cell.blockedImage.image = shop.blocked ? #imageLiteral(resourceName: "icn_shopslist_block_active"): #imageLiteral(resourceName: "icn_shopslist_block")
        cell.imgAvatar.image = shop.employee.oid == "5c43b67a580c2a7572594b60dd6560ee1d59b8fd" ? UIImage(named: "default-shop-icon") : UIImage(named: "default-icon")
        
        // Button Click
        cell.contactButton.tag = indexPath.row * 3
        //        cell.blockButton.tag = indexPath.row * 3 + 1
        cell.faveButton.tag = indexPath.row * 3 + 2
        
        cell.contactButton.addTarget(self, action: #selector(ShopsViewController.contactButtonTapped(sender:)), for: .touchUpInside)
        //        cell.blockButton.addTarget(self, action: #selector(ShopsViewController.blockButtonTapped(sender:)), for: .touchUpInside)
        cell.faveButton.addTarget(self, action: #selector(ShopsViewController.faveButtonTapped(sender:)), for: .touchUpInside)
        cell.blockButton.isHidden = true
        
        return cell
    }
}

extension ShopsViewController {
    
    @IBAction func segCtrlSwitched(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
            
        case 0:
            loadAllShops()
            self.tableView.isHidden = false
            self.mapView.isHidden = true
            break
        case 1:
            loadFavoriteShops()
            self.tableView.isHidden = false
            self.mapView.isHidden = true
            break
        case 2:
            self.tableView.isHidden = true
            self.mapView.isHidden = false
            
            
            if locationManager.location?.coordinate.latitude == nil
            {
                //                self.showAlert("", message: "Please enable your location service from setting")
            }else
            {
                let center = CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
                
                self.mapView.setRegion(region, animated: true)
            }
            
            
            
            //            loadBlockedShops()
            break
        default:
            break
        }
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
        } else {
            self.showAlert("", message: "Please enable your location service from setting")
        }
        
        
    }
    
    
    @objc fileprivate func contactButtonTapped(sender: UIButton) {
        
        if let navController = self.tabBarController?.viewControllers?[2] as? UINavigationController {
            
            if navController.viewControllers[0] is NewMessageViewController {
                
                let buttonPosition = sender.convert(CGPoint.zero, to: self.tableView)
                if let idxPath = self.tableView.indexPathForRow(at: buttonPosition) {
                    
                    DataManager.shared.contactShop = filteredShops[idxPath.row]
                    self.tabBarController?.selectedIndex = 2
                    
                }
                
            }
            
        }
        
    }
    
    @objc fileprivate func blockButtonTapped(sender: UIButton) {
        
        let index = (sender.tag - 1) / 3
        
        let filteredShop = filteredShops[index]
        
        if filteredShop.blocked {
            
            filteredShops[index].blocked = false
            
            let indexOfAppShops = shops.index {$0.oid == filteredShops[index].oid}
            filteredShop.unblock() { (shop, error, json) in
                if let shop = shop {
                    DataManager.shared.shops[indexOfAppShops!] = shop
                }
            }
            
        } else {
            
            filteredShops[index].blocked = true
            
            let indexOfAppShops = shops.index {$0.oid == filteredShops[index].oid}
            filteredShop.block() { (shop, error, json) in
                if let shop = shop {
                    DataManager.shared.shops[indexOfAppShops!] = shop
                    
                    DispatchQueue.main.async {
                        self.showAlert(shop.name + " blocked.", message: "")
                    }
                }
            }
        }
        
        let indexPath = IndexPath(row: index, section: 0)
        UIView.setAnimationsEnabled(false)
        tableView.reloadRows(at: [indexPath], with: .none)
        UIView.setAnimationsEnabled(true)
    }
    
    @objc fileprivate func faveButtonTapped(sender: UIButton) {
        
        let index = (sender.tag - 2) / 3
        
        let filteredShop = filteredShops[index]
        
        if filteredShop.favorited {
            
            filteredShops[index].favorited = false
            let indexOfAppShops = shops.index {$0.oid == filteredShops[index].oid}
            filteredShop.unfave() { (shop, error, json) in
                if let shop = shop {
                    DataManager.shared.shops[indexOfAppShops!] = shop
                }
            }
            
        } else {
            
            filteredShops[index].favorited = true
            let indexOfAppShops = shops.index {$0.oid == filteredShops[index].oid}
            filteredShop.fave() { (shop, error, json) in
                if let shop = shop {
                    DataManager.shared.shops[indexOfAppShops!] = shop
                    
                    DispatchQueue.main.async {
                        self.showAlert(shop.name + " added to Favorites.", message: "")
                    }
                }
            }
        }
        
        let indexPath = IndexPath(row: index, section: 0)
        UIView.setAnimationsEnabled(false)
        tableView.reloadRows(at: [indexPath], with: .none)
        UIView.setAnimationsEnabled(true)
    }
}


// MARK: - TableView Delegate & Datasource
extension ShopsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredShops.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: screenSize.width, height: 20.0))
        view.backgroundColor = UIColor.clear
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return configCell(indexPath: indexPath)
    }
}
