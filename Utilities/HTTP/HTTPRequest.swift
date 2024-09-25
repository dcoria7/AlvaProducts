//
//  HTTPRequest.swift
//
//  Created by Alex Pezzi on 2021-07-12.
//

import Foundation

public struct HTTPRequest {
    public let baseURL: URL
    public let path: String
    public let percentEncodedPath: String
    public let method: String
    public let contentType: ContentType
    public let parameters: [String: String]?
    public let percentEncodedParameters: [String: String]?
    public let formParameters: [String: String]?
    public let headers: [Header]?
    public let body: Data?
    public let cachePolicy: URLRequest.CachePolicy?
    
    public enum ContentType {
        case json
        case form
    }
    
    public struct Header {
        let name: String
        let value: String
    }
}

extension HTTPRequest {
    public func toURLRequest() -> URLRequest? {
        try? URLRequest(request: self)
    }
    public func toURLString() -> String? {
        toURLRequest()?.url?.absoluteString
    }
}

// MARK: - Factory

extension URLRequest {
    
    init(request: HTTPRequest) throws {
        
        // path
        let baseURL = request.baseURL
        
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
            throw HTTPError.invalidRequest(request: request)
        }
        
        // path
        if !request.path.isEmpty {
            components.path = components.path.appendingPathComponent(request.path)
            components.path.fixPathIfNeeded()
        }
        
        // percent encoded path
        if !request.percentEncodedPath.isEmpty {
            components.percentEncodedPath = components.percentEncodedPath.appendingPathComponent(request.percentEncodedPath)
            components.percentEncodedPath.fixPathIfNeeded()
        }
        
        // query
        if let parameters = request.parameters, !parameters.isEmpty {
            components.queryItems = parameters
                .map { .init(name: $0.key, value: $0.value) }
                .sortedAscendingOrder(by: \.name)
        }
        
        // percent encoded query
        if let percentEncodedParameters = request.percentEncodedParameters, !percentEncodedParameters.isEmpty {
            components.percentEncodedQueryItems = percentEncodedParameters
                .map { .init(name: $0.key, value: $0.value) }
                .sortedAscendingOrder(by: \.name)
        }
        
        guard let url = components.url else {
            throw HTTPError.invalidRequest(request: request)
        }
        
        var r = URLRequest(url: url)
        
        // method
        r.httpMethod = request.method
        
        // headers
        if let headers = request.headers, !headers.isEmpty {
            headers.forEach { r.addValue($0.value, forHTTPHeaderField: $0.name) }
        }
        
        // body
        switch request.contentType {
        case .json: r.httpBody = request.body
        case .form:
            if let formParameters = request.formParameters {
                let params = formParameters.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
                r.httpBody = params.data(using: String.Encoding.utf8)
            }
        }
        
        // cache policy
        if let cachePolicy = request.cachePolicy {
            r.cachePolicy = cachePolicy
        }
        
        self = r
    }
}

extension String {
    mutating func fixPathIfNeeded() {
        if !hasPrefix("/") {
            self = "/" + self
        }
    }
}

