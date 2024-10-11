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
	@inlinable func setDefaultBackgroundColor() -> some View {
		background(Color(red: 58/255, green: 58/255, blue: 60/255))
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
