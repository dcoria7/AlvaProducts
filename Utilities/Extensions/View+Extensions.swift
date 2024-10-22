//
//  View+Extensions.swift
//  AlvaProducts
//
//  Created by DC on 07/10/24.
//

import SwiftUI

extension View {
	
	func hideKeyboard() {
		UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
	}
	
	@ViewBuilder
	@inlinable func isHidden(_ hidden: Bool, remove: Bool = true) -> some View {
		if hidden {
			if !remove {
				self.hidden()
			}
		} else {
			self
		}
	}
	
	@ViewBuilder
	@inlinable func setDefaultBackgroundColor() -> some View {
		background(Color.make(rgb: "FBFBF9", alpha: 1.0))
	}
	
	@ViewBuilder
	@inlinable func setBlackBackgroundColor() -> some View {
		background(Color.make(rgb: "2d3030", alpha: 1.0))
	}
	
	@inlinable public func onChange(isTrue value: Bool, perform action: @escaping () -> Void) -> some View {
		self.onChange(of: value, perform: { value in
			if value {
				action()
			}
		})
	}
}

extension Color {
	
	static func random(randomOpacity: Bool = false) -> Color {
		Color(
			red: .random(in: 0...1),
			green: .random(in: 0...1),
			blue: .random(in: 0...1),
			opacity: randomOpacity ? .random(in: 0...1) : 1
		)
	}
}
