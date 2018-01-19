//
//  AppConfig.swift
//  Corner
//
//  Created by Marco Cabazal on 10/12/2016.
//  Copyright © 2016 Big Screen Entertainment. All rights reserved.
//
import UIKit

struct AppConfig {

	static let keychainService				= "com.corner.chat"

	static let apiHost 								= "https://bse-corner.herokuapp.com"
//	static let apiHost 								= "http://127.0.0.1:3005"
    static let firebaseURL						= "https://corner-5a3a9.firebaseio.com/"
	static let apiVersion 						= "v1"

	private static let isTestFlight = Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"

	static var debugMode: Bool {
		#if MTL_ENABLE_DEBUG_INFO
			return true
		#else
			return false
		#endif
	}

	static var appConfiguration: AppEnvironment {
		if debugMode {
			return .Debug
		} else if isTestFlight {
			return .TestFlight
		} else {
			return .AppStore
		}
	}
}

enum AppEnvironment {
	case Debug
	case TestFlight
	case AppStore
}

