//
//  HTTPSession.swift
//
//  Created by Alex Pezzi on 2021-07-12.
//

import Foundation
import Combine

/// A type that can inspect and optionally adapt a `URLRequest` in some manner if necessary.
public protocol RequestAdapter {
    func adapt(_ request: URLRequest) async throws -> URLRequest
}

/// Outcome of determination whether retry is necessary.
public enum RetryResult {
    case retry
    case doNotRetry
}

/// A type that determines whether a request should be retried after being excuted and encountering an error.
public protocol RequestRetrier {
    func retry(_ request: URLRequest, dueTo error: Error) async throws -> RetryResult
}

/// A type that can observe all HTTP requests and responses, and optionally throw an error.
public protocol ResponseInterceptor {
    func intercept(request: URLRequest, response: HTTPURLResponse) async throws
}

public protocol HTTPSession: AnyObject {
    var requestAdapter: RequestAdapter? { get set }
    var requestRetrier: RequestRetrier? { get set }
    var responseInterceptor: ResponseInterceptor? { get set }
    func data(request: URLRequest) async throws -> (data: Data, response: HTTPURLResponse)
    func data<Mapper: HTTPResponseMapper>(request: URLRequest, mapper: Mapper) async throws -> Mapper.Output
    func data<Mapper: HTTPResponseMapper>(request: HTTPRequest, mapper: Mapper) async throws -> Mapper.Output
}
