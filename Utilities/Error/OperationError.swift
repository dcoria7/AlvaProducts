//
//  OperationError.swift
//  Sensical
//
//  Created by Alex Pezzi on 2021-03-02.
//

import Foundation

struct OperationError: Codable, Error {
	
	enum Code: String {
		case authenticationRequired = "authentication-required"
		case securityChallengeFailed = "security-challenge-failed"
		case invalidCredential = "invalid-credential"
		case emailAlreadyExists = "already-exist-email"
		case groupNotFound = "group-not-found"
		case notFound = "not-found"
		case unknown
	}
	
	let code: Code
	let message: String
}

extension OperationError {
	static let authenticationRequired: Self = .init(
		code: .authenticationRequired,
		message: "Full authentication is required to access this resource")
	
	static let failedToRetrieveCustomData: Self = .init(
		code: .unknown,
		message: "Failed to retrieve CustomData")
	
	static let noParentProfileFound: Self = .init(
		code: .unknown,
		message: "No Parent profile found in account")
}

extension OperationError.Code: Codable {
	
	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		self = OperationError.Code(rawValue: try container.decode(String.self)) ?? .unknown
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(self)
	}
}

extension Error {
	
	var operationError: OperationError? {
		self as? OperationError
	}
}
