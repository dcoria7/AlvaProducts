//
//  HTTPHeader.swift
//  MV-Project
//
//  Created by Daniel Coria on 02/08/23.
//

import Foundation

public enum HTTPHeader: String {
    case authorization = "Authorization"
    case origin = "Origin"
    case refreshToken = "refreshtoken"
    case cookie = "Cookie"
    case contentType = "Content-Type"
    case redirectUri = "redirecturi"
    case x_tv3_profiles = "x-tv3-profiles"
}
