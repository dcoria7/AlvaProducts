//
//  HTTPResponseMapper.swift
//  Sensical
//
//  Created by Alex Pezzi on 2021-02-08.
//

import Foundation

public protocol HTTPResponseMapper {
    associatedtype Output
    func map(data: Data, response: HTTPURLResponse) throws -> Output
    func map(error: Error) -> Error
}

public extension HTTPResponseMapper {
    func map(error: Error) -> Error { error }
}
