//
//  Response.swift
//  Corner
//
//  Created by MobileGod on 26/01/2017.
//  Copyright © 2017 BSE. All rights reserved.
//

struct Response {
	
	var id:			String!
	var sellerName: String!
	var shop:		OldShop
	var text:		String!
	var date:		String!
	
	init(id: String,
	     sellerName: String,
	     shop: OldShop,
	     text: String,
	     date: String) {
		
		self.id = id
		self.sellerName = sellerName
		self.shop = shop
		self.text = text
		self.date = date
	}
	//	init(withJson json: JSON) {
	//
	//		self.message = json["message"].stringValue
	//		self.waitingInterval = json["time"].doubleValue
	//	}
}
