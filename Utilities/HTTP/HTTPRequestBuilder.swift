//
//  HTTPRequestBuilder.swift
//
//  Created by Alex Pezzi on 2021-07-12.
//

import Foundation

public final class HTTPRequestBuilder {
    
    private var baseURL: URL
    private var path: String = ""
    private var percentEncodedPath: String = ""
    private var method: HTTPMethod = .get
    private var contentType: HTTPRequest.ContentType = .json
    private var parameters: [String: String] = .init()
    private var percentEncodedParameters: [String: String] = .init()
    private var formParameters: [String: String] = .init()
    private var headers: [HTTPRequest.Header] = .init()
    private var body: Data?
    private var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    
    public init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    public func set(baseURL: URL) -> Self {
        self.baseURL = baseURL
        return self
    }
    
    public func set(path: String) -> Self {
        self.path = path
        return self
    }
    
    public func set(percentEncodedPath: String) -> Self {
        self.percentEncodedPath = percentEncodedPath
        return self
    }
    
    public func appendToBaseURL(value: String) -> Self {
        let string = baseURL.absoluteString + value
        guard let url = URL(string: string) else {
            return self
        }
        return set(baseURL: url)
    }
    
    public func append(path: String) -> Self {
        self.path = self.path.appendingPathComponent(path)
        return self
    }
    
    public func set(method: HTTPMethod) -> Self {
        self.method = method
        return self
    }
    
    public func addParameter(name: String, value: String?) -> Self {
        self.parameters[name] = value
        return self
    }
    
    public func addPercentEncodedParameter(name: String, value: String) -> Self {
        self.percentEncodedParameters[name] = value
        return self
    }
    
    public func addFormParameter(name: String, value: String) -> Self {
        self.formParameters[name] = value
        return self
    }
    
    public func addHeader(name: String, value: String) -> Self {
        self.headers.append(.init(name: name, value: value))
        return self
    }
    
    public func addHeader(header: HTTPHeader, value: String) -> Self {
        self.headers.append(.init(name: header.rawValue, value: value))
        return self
    }
    
    public func set(body: Data) -> Self {
        self.body = body
        return self
    }
    
    public func set(cachePolicy: URLRequest.CachePolicy) -> Self {
        self.cachePolicy = cachePolicy
        return self
    }
    
    public func build() -> HTTPRequest {
        .init(
            baseURL: baseURL,
            path: path,
            percentEncodedPath: percentEncodedPath,
            method: method.rawValue,
            contentType: contentType,
            parameters: parameters,
            percentEncodedParameters: percentEncodedParameters,
            formParameters: formParameters,
            headers: headers,
            body: body,
            cachePolicy: cachePolicy
        )
    }
}

// MARK: - Convenience

extension HTTPRequestBuilder {
    
    public func setAcceptJSON() -> Self {
        contentType = .json
        return addHeader(header: .contentType, value: "application/json")
    }
    
    public func setAcceptFormData() -> Self {
        contentType = .form
        return addHeader(header: .contentType, value: "application/x-www-form-urlencoded")
    }
    
    public func set(JSONBody: Any) -> Self {
        body = try? JSONSerialization.data(withJSONObject: JSONBody, options: .prettyPrinted)
        return setAcceptJSON()
    }
    
    public func set<T: Encodable>(JSONBody: T) -> Self {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        body = try? encoder.encode(JSONBody)
        return setAcceptJSON()
    }
    
    public func setMultipart(formData: Data, key: String, fileName: String) -> Self {
        let boundary = "--------------------------\(UUID().uuidString)"
        
        let requestData = createRequestBody(data: formData, boundary: boundary, key: key, fileName: fileName)
        self.body = requestData
        return addHeader(header: .contentType, value: "multipart/form-data; boundary=\(boundary)")
    }
    
    private func createRequestBody(data: Data, boundary: String, key: String, fileName: String) -> Data {
        let lineBreak = "\r\n"
        var requestBody = Data()
        
        requestBody.append("\(lineBreak)--\(boundary + lineBreak)" .data(using: .utf8)!)
        requestBody.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(fileName)\"\(lineBreak)" .data(using: .utf8)!)
        requestBody.append("Content-Type: image/png \(lineBreak + lineBreak)" .data(using: .utf8)!)
        requestBody.append(data)
        requestBody.append("\(lineBreak)--\(boundary)--\(lineBreak)" .data(using: .utf8)!)
        
        return requestBody
    }
}
