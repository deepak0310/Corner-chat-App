//
//  ObjectMapper+MAC.swift
//  Corner
//
//  Created by Marco Cabazal on 10/12/2016.
//  Copyright © 2016 Big Screen Entertainment. All rights reserved.
//

import ObjectMapper

open class RailsDateTransform: TransformType {

	public typealias Object = Date
	public typealias JSON = String

	open func transformFromJSON(_ value: Any?) -> Date? {

		if let dateString = value as? String {
			let formatter = DateFormatter()
			formatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss.SSSZ"

			return formatter.date(from: dateString)
		}

		return nil
	}

	open func transformToJSON(_ value: Date?) -> String? {

		if let dateString = value {
			let formatter = DateFormatter()
			formatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss.SSSZ"

			return formatter.string(from: dateString)
		}

		return nil
	}
}
