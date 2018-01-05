//
//  Customer.swift
//  Corner
//
//  Created by MobileGod on 04/02/2017.
//  Copyright © 2017 BSE. All rights reserved.
//


struct Customer {
	
	var id:		String!
	var name:	String!
	var street: String!
	var city:	String!
	var isContact:	Bool
	var isFavorite: Bool
	var isBlock:	Bool
	
	init(id: String,
	     name: String,
	     street: String,
	     city: String,
	     isContact: Bool,
	     isFavorite: Bool,
	     isBlock: Bool) {
		
		self.id = id
		self.name = name
		self.street = street
		self.city = city
		self.isContact = isContact
		self.isFavorite = isFavorite
		self.isBlock = isBlock
	}
}
