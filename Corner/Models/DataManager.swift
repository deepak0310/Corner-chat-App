//
//  DataManager.swift
//  Corner
//
//  Created by Marco Cabazal on 03/27/2017.
//  Copyright © 2017 BSE. All rights reserved.
//

import Foundation

class DataManager {
    
    static let shared = DataManager()
    private init() {}
    
    var shops = [Shop]()
    
    var contactShop: Shop?
    
    var unblockedShops: [Shop] {
        return shops.filter { !$0.blocked }.map { $0 }
    }
    
    var shopEmployees: [User] {
        return shops.filter { !$0.blocked }.map { $0.employee }
    }
    
    var blockedShopEmployees: [User] {
        return shops.filter { $0.blocked }.map { $0.employee }
    }
    
    var currentUser: User?
    
    var issues = [Issue]()
    
    var conversations: [Conversation] {
        
        var conversationsTemp = [Conversation]()
        for issue in issues {
            conversationsTemp.append(contentsOf: issue.conversations)
        }
        return conversationsTemp
    }
}
