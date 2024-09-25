//
//  FieldError.swift
//  Sensical
//
//  Created by Alex Pezzi on 2021-03-02.
//

import Foundation

struct FieldError: Codable, Error {
	let field: String
	let code: Code
	let message: String
}

extension FieldError {
	enum Code: String {
		case weakPassword = "NotWeakPassword"
		case invalidAuthnIdentifier = "ValidAuthnIdentifier" // email
		case unknown
	}
}

extension FieldError.Code: Codable {
	
	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		self = FieldError.Code(rawValue: try container.decode(String.self)) ?? .unknown
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(self)
	}
}
