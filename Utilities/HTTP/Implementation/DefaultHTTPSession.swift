//
//  DefaultHTTPSession.swift
//
//  Created by Alex Pezzi on 2021-07-12.
//

import Foundation
import Combine

public final class DefaultHTTPSession {
    
    public var requestAdapter: RequestAdapter?
    public var requestRetrier: RequestRetrier?
    public var responseInterceptor: ResponseInterceptor?
    
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    private func adaptRequestIfNeeded(_ request: URLRequest) async throws -> URLRequest {
        if let adapter = requestAdapter {
            return try await adapter.adapt(request)
        } else {
            return request
        }
    }
    
    private func retryRequestIfNeeded(_ request: URLRequest, dueTo error: Error) async throws -> (data: Data, response: HTTPURLResponse) {
        if let retrier = requestRetrier {
            let result = try await retrier.retry(request, dueTo: error)
            switch result {
            case .retry:
                return try await data(request: request)
            case .doNotRetry:
                throw error
            }
        } else {
            throw error
        }
    }
    
    private func interceptResponseIfNeeded(request: URLRequest, response: HTTPURLResponse) async throws {
        if let interceptor = responseInterceptor {
            try await interceptor.intercept(request: request, response: response)
        }
    }
}

// MARK: - HTTPSession

extension DefaultHTTPSession: HTTPSession {
    
    public func data(request: URLRequest) async throws -> (data: Data, response: HTTPURLResponse) {
        let request = try await adaptRequestIfNeeded(request)
        do {
            let (data, response) = try await session.fetch(for: request)
            try await interceptResponseIfNeeded(request: request, response: response)
            return (data, response)
        } catch {
            return try await retryRequestIfNeeded(request, dueTo: error)
        }
    }
    
    public func data<Mapper: HTTPResponseMapper>(request: URLRequest, mapper: Mapper) async throws -> Mapper.Output {
        do {
            let (data, response) = try await data(request: request)
            try Task.checkCancellation()
            return try mapper.map(data: data, response: response)
        } catch {
            throw mapper.map(error: error)
        }
    }
    
    public func data<Mapper: HTTPResponseMapper>(request: HTTPRequest, mapper: Mapper) async throws -> Mapper.Output {
        do {
            let request = try URLRequest(request: request)
            return try await data(request: request, mapper: mapper)
        } catch {
            throw mapper.map(error: error)
        }
    }
}
