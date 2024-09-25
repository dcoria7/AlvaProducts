//
//  JSONTypes.swift
//  BasicProject
//
//  Created by DC on 22/04/20.
//  Copyright © 2020 DC. All rights reserved.
//

import Foundation

typealias JSON = [AnyHashable: Any]
typealias JSONArrayType = [[String:Any]]
typealias JSONObjectType = [String:Any]
typealias KeyValueStringAnyType = [String:Any]
typealias KeyValueStringType = [String:String]

enum JSONResult {
    case object(result: JSONObjectType)
    case array(result: JSONArrayType)
}

// Allows conforming types to support initialization using data in the form of a jsonObject
protocol JSONObjectDecodable {
    
    init?(JSONObject: JSONObjectType)
}

// Allows conforming types to support initialization using data in the form of a jsonArray
protocol JSONArrayDecodable {
    
    init?(JSONArray: JSONArrayType)
}
