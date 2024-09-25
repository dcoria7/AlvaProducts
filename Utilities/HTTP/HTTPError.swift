//
//  HTTPError.swift
//  Sensical
//
//  Created by Alex Pezzi on 2021-01-20.
//

import Foundation

enum HTTPError: Error {
	/// Indicates that the requested `URL` is invalid.
	case invalidRequest(request: HTTPRequest)
	/// Indicates that the response is not a valid HTTP response.
	case invalidResponse(response: URLResponse)
	/// Indicates that raw data could not be decoded
	case cannotDecodeRawData
}
