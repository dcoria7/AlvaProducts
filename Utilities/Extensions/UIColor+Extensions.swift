//
//  Untitled.swift
//  ClickLocal
//
//  Created by DC on 18/10/24.
//

import UIKit
import SwiftUI

extension Color {
	public static func green() -> Color {
		Color(make(rgb: "0d8f0d", alpha: 1.0))
	}
	
	public static func customBlack() -> Color {
		Color(make(rgb: "2d3030", alpha: 1.0))
	}
	
	public static func customWhite() -> Color {
		Color(make(rgb: "FBFBF9", alpha: 1.0))
	}
	
	public static func make(rgb: String, alpha: CGFloat) -> Color {
		Color(UIColor(hexString: rgb).withAlphaComponent(alpha))
	}
}

extension UIColor {
	
	public static func customBlack() -> UIColor {
		make(rgb: "2d3030", alpha: 1.0)
	}
	
	public static func customWite() -> UIColor {
		make(rgb: "FBFBF9", alpha: 1.0)
	}
	
	public static func make(rgb: String, alpha: CGFloat) -> UIColor {
		UIColor(hexString: rgb).withAlphaComponent(alpha)
	}
	
	public convenience init(hexString: String) {
		let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
		var int = UInt64()
		Scanner(string: hex).scanHexInt64(&int)
		let a, r, g, b: UInt64
		switch hex.count {
			case 3: // RGB (12-bit)
				(a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
			case 6: // RGB (24-bit)
				(a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
			case 8: // ARGB (32-bit)
				(a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
			default:
				(a, r, g, b) = (255, 0, 0, 0)
		}
		self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
	}
}

