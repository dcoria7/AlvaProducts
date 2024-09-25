//
//  String+Extension.swift
//  MV-Project
//
//  Created by Daniel Coria on 02/08/23.
//

import Foundation

extension String {
    
    public func appendingPathComponent(_ str: String) -> String {
        (self as NSString).appendingPathComponent(str)
    }
}
