//
//  Shop.swift
//  Corner
//
//  Created by Marco Cabazal on 11/19/2016.
//  Copyright © 2016 Big Screen Entertainment. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper
import SwiftyJSON
import CoreLocation

class Shop: Mappable {

	var oid         = ""
	var name        = ""
	var employee    = User()
	var street			= ""
	var locality		= ""
	var city        = ""
	var province    = ""
	var country     = ""
	var zipCode     = ""
	var long        = ""
	var lat         = ""
	var favorited   = false
	var blocked     = false
	var contact     = false
	var createdAt: Date?
	var updatedAt: Date?
    var distance : Double = 0.0

	static let keyPath = "shop"
	static let collectionKeyPath = "shops"

	typealias ShopResponse = (Shop?, Error?, JSON?) -> Void

	func mapping(map: Map) {
		oid <- map["oid"]
		name <- map["name"]
        
        
		employee <- map["employee"]
        print("-------------------")
        print(name + employee.oid)
        print("-------------------")
        
		street <- map["street"]
		locality <- map["locality"]
		city <- map["city"]
		province <- map["province"]
		country <- map["country"]
		zipCode <- map["zipCode"]
		long <- map["long"]
		lat <- map["lat"]
		favorited <- map["favorited"]
		blocked <- map["blocked"]
		contact <- map["contact"]
		createdAt <- (map["created_at"], RailsDateTransform())
		updatedAt <- (map["updated_at"], RailsDateTransform())
	}

	required convenience init?(map: Map) {
		self.init()
	}

    static func fetchAll() {
        if APIManager.keychain[Prefs.tokenKey] != nil {
            APIManager.shared.getCollection(of: Shop.self, router: Router.getShops, keyPath: Shop.collectionKeyPath) { (shops, error, json) in
                
                if let shops = shops {
                    
                   
                    
                    
                    
                    DataManager.shared.shops = shops
                    
                    var counter : Int = 0
                    
                    for shop in DataManager.shared.shops
                    {
                        let SHop : Shop = shop
                        
                        
                        let address = "\(SHop.street), \(SHop.locality), \(SHop.province), \(SHop.country), \(SHop.zipCode)"
                        
                        let geoCoder = CLGeocoder()
                        geoCoder.geocodeAddressString(address) { (placemarks, error) in
                            guard
                                let placemarks = placemarks,
                                let location = placemarks.first?.location
                                else {
                                    return
                            }
                            counter = counter + 1
                            
                            SHop.lat = "\(location.coordinate.latitude)"
                            SHop.long = "\(location.coordinate.longitude)"
                            
                            if counter == DataManager.shared.shops.count
                            {
                                print("\(counter) counter value")
                                 NotificationCenter.default.post(name: .gotShops, object: nil)
                            }
                            
                            // Use your location
                        }
                    
                    }
                    
                    
                    
                    
                    
                    print("got shops via API.")
                    //				Issue.create(message: "hello, world.", shops: nil)
                    guard let user = DataManager.shared.currentUser else { return }
                    Issue.loadIssues(user: user) { issues, error in
                        NotificationCenter.default.post(name: .gotIssues, object: nil)
                    }
                   
                    
                } else {
                    print("fetchShopsError \(error!.localizedDescription) \(json!)")
                }
            }
        }
    }

	func fave(completion: @escaping ShopResponse) {
		APIManager.shared.request(object: Shop.self, router: Router.faveShop(self), keyPath: Shop.keyPath, completion: completion)
	}

	func unfave(completion: @escaping ShopResponse) {
		APIManager.shared.request(object: Shop.self, router: Router.unfaveShop(self), keyPath: Shop.keyPath, completion: completion)
	}

	func block(completion: @escaping ShopResponse) {
		APIManager.shared.request(object: Shop.self, router: Router.blockShop(self), keyPath: Shop.keyPath, completion: completion)
	}

	func unblock(completion: @escaping ShopResponse) {
		APIManager.shared.request(object: Shop.self, router: Router.unblockShop(self), keyPath: Shop.keyPath, completion: completion)
	}
}
