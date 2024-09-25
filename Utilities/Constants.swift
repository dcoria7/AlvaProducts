//
//  Constants.swift
//  BasicProject
//
//  Created by DC on 22/04/20.
//  Copyright © 2020 DC. All rights reserved.
//

import Foundation

enum NetworkErrorLogin: Error {
    
    case urlInvalid
    case parse
    case invalidCredential
    case unkwonError
    
}

class Constants: NSObject {

    static let versionApp = "1.0"
    static let success = 200
    static let successCreated = 201
    static let successWithMessage = 401
    static let successWithMessage2 = 409
    static let successWithError = 422
    static let codeErrorRequestDriver = 210
    
    public enum urlWS: String {
        case sample = "sample"
        case characters = "/v1/public/characters"
        case comics = "/v1/public/characters/%i/comics"
    }
    
}


