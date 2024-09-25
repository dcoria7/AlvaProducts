//
//  BasicServices.swift
//  BasicProject
//
//  Created by DC on 22/04/20.
//  Copyright © 2020 DC. All rights reserved.
//

import Foundation
import Combine

protocol StoreHTTPClient {
    
    func fetchProducts() async throws -> [Product]
}


final class DefaultStoreHTTPClient: StoreHTTPClient {
        
    private let session: HTTPSession = DefaultHTTPSession()
    private var cancellable: AnyCancellable?
    
    func fetchProducts() async throws -> [Product] {
        let request = HTTPRequestBuilder(baseURL: URL(string: "https://fakestoreapi.com")!)
            .set(path: "/products")
            .build()
        
        return try await session.data(request: request, mapper: ProductsMapper())
    }
    
    // MARK: Private
    
    private func makeBaseBuilder(url: URL) -> HTTPRequestBuilder {
        HTTPRequestBuilder(baseURL: url)
    }
    
}
                                      
                                      
final class ProductsMapper: HTTPResponseMapper {
            
    typealias Output = [Product]
            
    func map(data: Data, response: HTTPURLResponse) throws -> [Product] {
        switch response.statusCode {
        case 200:
            return try data.decode()
        default:
            throw HTTPError.cannotDecodeRawData
        }
    }
}
