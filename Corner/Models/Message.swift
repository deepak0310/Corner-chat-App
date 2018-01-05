//
//  Message.swift
//  Corner
//
//  Created by MobileGod on 25/01/2017.
//  Copyright © 2017 BSE. All rights reserved.
//


// Message for [Store -> Customer]

struct StoreMessage {
	
	var id:		String!
	var text:	String!
	var date:	String!
	
	init(id: String,
	     text: String,
	     date: String) {
		
		self.id = id
		self.text = text
		self.date = date
	}
	//	init(withJson json: JSON) {
	//
	//		self.message = json["message"].stringValue
	//		self.waitingInterval = json["time"].doubleValue
	//	}
}

struct Message {
    
    var timestamp: CLong
    var negatedTimestamp: CLong
    var dayTimestamp: CLong
    var body: String
    var from: String
    var shop: String
    var employee: String
    var email: String
    
    init(timestamp: CLong, negatedTimestamp: CLong, dayTimestamp: CLong, body: String, from: String, shop: String, employee: String, email: String) {
        self.timestamp = timestamp
        self.negatedTimestamp = negatedTimestamp
        self.dayTimestamp = dayTimestamp
        self.body = body
        self.from = from
        self.shop = shop
        self.employee = employee
        self.email = email
    }
    
    func toAnyObject() -> [AnyHashable:Any] {
        return ["timestamp":timestamp, "negatedTimestamp":negatedTimestamp, "dayTimestamp":dayTimestamp, "body":body, "from":from, "shop":shop, "employee":employee, "email":email] as [AnyHashable:Any]
    }
}

struct ReturnMessage {
    
    var timestamp: CLong
    var negatedTimestamp: CLong
    var dayTimestamp: CLong
    var body: String
    var to: String
    var name: String
    
    init(timestamp: CLong, negatedTimestamp: CLong, dayTimestamp: CLong, body: String, to: String, name: String) {
        self.timestamp = timestamp
        self.negatedTimestamp = negatedTimestamp
        self.dayTimestamp = dayTimestamp
        self.body = body
        self.to = to
        self.name = name
    }
    
    func toAnyObject() -> [AnyHashable:Any] {
        return ["timestamp":timestamp, "negatedTimestamp":negatedTimestamp, "dayTimestamp":dayTimestamp, "body":body, "to":to, "name":name] as [AnyHashable:Any]
    }
}

// Message for [Customer -> Store]

struct CustomerMessage {
	
	var id:				String!
	var customerId:		String!
	var customerName:	String!
	var category:		String!
	var text:			String!
	var date:			String!
	var status:			String!
	
	
	init(id:			String,
	     customerId:	String,
	     name:			String,
	     category:		String,
	     text:			String,
	     date:			String,
	     status:		String) {
		
		self.id = id
		self.customerId = customerId
		self.customerName = name
		self.category = category
		self.text = text
		self.date = date
		self.status = status
	}
}
