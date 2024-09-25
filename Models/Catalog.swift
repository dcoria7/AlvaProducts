//
//  Catalog.swift
//  MV-Project
//
//  Created by Daniel Coria on 07/08/23.
//

import Foundation


struct Product: Decodable, Identifiable {
    let id: Int
    let title: String
    let description: String
    let image: String
}

@MainActor
class Store: ObservableObject {
    private var storeHTTPClient: StoreHTTPClient
    
    @Published var products: [Product] = []
    
    init(storeHTTPClient: StoreHTTPClient) {
        self.storeHTTPClient = storeHTTPClient
    }
    
    func loadProducts() async throws {
        products = try await storeHTTPClient.fetchProducts()
    }
    
}
