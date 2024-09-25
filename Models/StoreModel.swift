//
//  StoreModel.swift
//  MV-Project
//
//  Created by Daniel Coria on 01/08/23.
//

import Foundation

class StoreModel: ObservableObject {
    private var storeHTTPClient: StoreHTTPClient
    
    init(storeHTTPClient: StoreHTTPClient) {
        self.storeHTTPClient = storeHTTPClient
    }
    
    @Published var characters: [Character] = []
    
}
