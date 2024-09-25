//
//  URLSession+Extensions.swift
//
//  Created by Alex Pezzi on 2022-03-24.
//

import Foundation

extension URLSession {
    
    public func fetch(for request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw HTTPError.invalidResponse(response: response)
        }
        return (data, httpResponse)
    }
}

