//
//  JSONDecoder+Extension.swift
//  MV-Project
//
//  Created by Daniel Coria on 01/08/23.
//

import Foundation

extension JSONDecoder {
    
    func decode<T: Decodable>(_ data: Data) throws -> T {
        try decode(T.self, from: data)
    }
}

extension Data {
    
    func decode<T: Decodable>(_ decoder: JSONDecoder = .init()) throws -> T {
        try decoder.decode(self)
    }
}
