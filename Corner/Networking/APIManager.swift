//
//  APIManager.swift
//  Corner
//
//  Created by Marco Cabazal on 10/12/2016.
//  Copyright © 2016 Big Screen Entertainment. All rights reserved.
//

import Alamofire
import ObjectMapper
import KeychainAccess
import SwiftyJSON
import FacebookCore

class APIManager {

	static let shared = APIManager()
	static let keychain = Keychain(service: AppConfig.keychainService)

	private init() { }

	typealias GenericResponse<T> = (T?, Error?, JSON?) -> Void
	typealias GenericArrayResponse<T> = ([T]?, Error?, JSON?) -> Void
}

extension APIManager {

	func getCollection<T: Mappable>(of: T.Type, router: URLRequestConvertible, keyPath: String, completion: @escaping GenericArrayResponse<T>) {

		Alamofire.request(router)
			.validate()
			.responseArray(keyPath: keyPath) { (response: DataResponse<[T]>) in

				var json: JSON?

				if let data = response.data {
					json = JSON(data: data)
				}

				switch response.result {
				case .success:
					if let resultsArray = response.result.value as [T]! {
						completion(resultsArray, nil, json)
					}
				case .failure(let error):
					print("API Error \(router.urlRequest.debugDescription): \(error.localizedDescription)")
					completion(nil, error, json)
				}
		}
	}

	func request<T: Mappable>(object: T.Type, router: URLRequestConvertible, keyPath: String, completion: @escaping GenericResponse<T>) {

		Alamofire.request(router)
			.validate()
			.responseObject(keyPath: keyPath) { (response: DataResponse<T>) in

				var json: JSON?

				if let data = response.data {
					json = JSON(data: data)
				}

				switch response.result {
				case .success:
					if let result = response.result.value {
						completion(result, nil, json)
					}
				case .failure(let error):

					print("API Error \(router.urlRequest.debugDescription): \(error.localizedDescription)\n\(String(describing: json))")
					completion(nil, error, json)
				}
		}
	}
}


