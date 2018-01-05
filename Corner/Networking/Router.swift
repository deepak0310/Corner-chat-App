//
//  Router.swift
//  Corner
//
//  Created by Marco Cabazal on 10/13/2016.
//  Copyright © 2016 Big Screen Entertainment. All rights reserved.
//

import Foundation
import Alamofire
import KeychainAccess
import FacebookCore

enum Router: URLRequestConvertible {
    
    static let keychain = Keychain(service: AppConfig.keychainService)
    
    case getFacebookProfile
    case signinWithFacebook(email: String, facebookID: String, facebookToken: String, facebookProfilePhoto: String, firstName: String, lastName: String, gender: String)
    case signinWithGoogle(email: String, googleID: String, googleProfilePhoto: String, firstName: String, lastName: String)
    case signup(email: String, password: String, firstName: String, lastName: String)
    case signin(email: String, password: String)
    case updateUser(user: User)
    
    case refreshTokens
    
    case sendDeviceToken(apns: String)
    case disableNotifications
    
    case notifyUser(source: User, destination: User, message: String)
    
    case updateShop(Shop)
    case getShops
    case faveShop(Shop)
    case unfaveShop(Shop)
    case blockShop(Shop)
    case unblockShop(Shop)
    
    func request() -> (method: Alamofire.HTTPMethod, url: URL, parameters: Parameters?, token: String?) {
        
        switch self {
        case .getFacebookProfile:
            let parameters: Parameters = [
                "fields": "id, first_name, last_name, name, email, about, birthday, location, timezone, website, gender, picture.type(large)",
                "access_token": AccessToken.current!.authenticationToken
            ]
            return (.get, URL(string: "\(APIEndpoints.userProfileAPI)")!, parameters, nil)
            
        case .signinWithFacebook(let email, let facebookID, let facebookToken, let facebookProfilePhoto, let firstName, let lastName, let gender):
            let parameters = [
                "user": [	"email": email, "fb_id": facebookID, "fb_token": facebookToken, "fb_profile_photo": facebookProfilePhoto,
                         	"gender": gender, "first_name": firstName, "last_name": lastName
                ]]
            return (.post, URL(string: "\(APIEndpoints.signinWithFacebookAPI)")!, parameters, nil)
            
        case .signinWithGoogle(let email, let googleID, let googleProfilePhoto, let firstName, let lastName):
            let parameters = [
                "user": [	"email": email, "google_id": googleID, "google_profile_photo": googleProfilePhoto,
                         	"first_name": firstName, "last_name": lastName
                ]
            ]
            return (.post, URL(string: "\(APIEndpoints.signinWithGoogleAPI)")!, parameters, nil)
            
        case .signup(let email, let password, let firstName, let lastName):
            let parameters = [
                "user" : [
                    "email": email,
                    "password": password,
                    "firstName": firstName,
                    "lastName": lastName
                ]
            ]
            return (.post, URL(string: "\(APIEndpoints.signupAPI)")!, parameters, nil)
            
        case .signin(let email, let password):
            let parameters = [
                "user" : [
                    "email": email,
                    "password": password
                ]
            ]
            return (.post, URL(string: "\(APIEndpoints.signinAPI)")!, parameters, nil)
            
        case .updateUser(let user):
            let parameters = [
                "shop" : [
                    "first_name" : user.firstName,
                    "last_name" : user.lastName,
                ]
            ]
            
            return (.patch, URL(string: "\(APIEndpoints.profileAPI)")!, parameters, APIManager.keychain[Prefs.tokenKey]!)
            
        case .refreshTokens:
            return (.get, URL(string: "\(APIEndpoints.refreshAuthTokensAPI)")!, nil, APIManager.keychain[Prefs.tokenKey]!)
            
        case .sendDeviceToken(let apns):
            let parameters = [
                "device_token": [
                    "apns": apns,
                    "production": AppConfig.appConfiguration == .AppStore ? 1 : 0
                ]
            ]
            return (.post, URL(string: APIEndpoints.notificationsAPI)!, parameters, APIManager.keychain[Prefs.tokenKey]!)
            
        case .disableNotifications:
            return (.delete, URL(string: APIEndpoints.notificationsAPI)!, nil, APIManager.keychain[Prefs.tokenKey]!)
            
        case .notifyUser(let source, let destination, let message):
            let parameters = [
                "notification": [
                    "source_oid": source.oid,
                    "destination_oid": destination.oid,
                    "message": message,
                    "production": AppConfig.appConfiguration == .AppStore ? 1 : 0
                ]
            ]
            
            return (.put, URL(string: "\(APIEndpoints.notifyAPI)")!, parameters, APIManager.keychain[Prefs.tokenKey]!)
            
        case .updateShop(let shop):
            let parameters = [
                "shop" : [
                    "name" : shop.name,
                    "street" : shop.street,
                    "locality" : shop.locality,
                    "province" : shop.province
                ]
            ]
            
            return (.patch, URL(string: "\(APIEndpoints.shopProfileAPI)")!, parameters, APIManager.keychain[Prefs.tokenKey]!)
            
        case .getShops:
            return (.get, URL(string: "\(APIEndpoints.shopsAPI)")!, nil, APIManager.keychain[Prefs.tokenKey]!)
            
        case .faveShop(let shop):
            return (.post, URL(string: "\(APIEndpoints.shopsAPI)/\(shop.oid)/fave")!, nil, APIManager.keychain[Prefs.tokenKey]!)
            
        case .unfaveShop(let shop):
            return (.delete, URL(string: "\(APIEndpoints.shopsAPI)/\(shop.oid)/fave")!, nil, APIManager.keychain[Prefs.tokenKey]!)
            
        case .blockShop(let shop):
            return (.post, URL(string: "\(APIEndpoints.shopsAPI)/\(shop.oid)/block")!, nil, APIManager.keychain[Prefs.tokenKey]!)
            
        case .unblockShop(let shop):
            return (.delete, URL(string: "\(APIEndpoints.shopsAPI)/\(shop.oid)/block")!, nil, APIManager.keychain[Prefs.tokenKey]!)
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        let request = self.request()
        
        var urlRequest = URLRequest(url: request.url)
        urlRequest.httpMethod = request.method.rawValue
        
        if let token = request.token {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let params = request.parameters {
            urlRequest = try URLEncoding.default.encode(urlRequest, with: params)
        }
        
        return urlRequest
    }
}
