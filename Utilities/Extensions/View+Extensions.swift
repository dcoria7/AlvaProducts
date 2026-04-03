//
//  View+Extensions.swift
//  ClickLocal
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
		background(Color.make(rgb: "FBFBF9", alpha: 1.0))
	}
	
	@ViewBuilder
	@inlinable func setBlackBackgroundColor() -> some View {
		background(Color.make(rgb: "2d3030", alpha: 1.0))
	}
}

extension View {
	
	@inlinable public func onChange<V>(unwrapping value: V?, perform action: @escaping (V) -> Void) -> some View where V : Equatable {
		self.onChange(of: value) { _, value in
			if let unwrapped = value {
				action(unwrapped)
			}
		}
	}
	
	@inlinable public func onChange(isTrue value: Bool, perform action: @escaping () -> Void) -> some View {
		self.onChange(of: value) { _, value in
			if value {
				action()
			}
		}
	}
	
	@inlinable public func onChange(isFalse value: Bool, perform action: @escaping () -> Void) -> some View {
		self.onChange(of: value) { _, value in
			if !value {
				action()
			}
		}
	}
	
	@inlinable public func onFinish<V>(of value: Bool,
									   unwrapping unwrappedValue: V?,
									   perform action: @escaping (V) -> Void) -> some View where V : Equatable {
		self.onChange(of: value) { _, value in
			if value, let unwrapped = unwrappedValue {
				action(unwrapped)
			}
		}
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
	
}

public extension View {
	func onFirstAppear(perform action: @escaping () -> Void) -> some View {
		modifier(ViewFirstAppearModifier(perform: action))
	}
}

struct ViewFirstAppearModifier: ViewModifier {
	@State private var didAppearBefore = false
	private let action: () -> Void
	
	init(perform action: @escaping () -> Void) {
		self.action = action
	}
	
	func body(content: Content) -> some View {
		content.onAppear {
			guard !didAppearBefore else { return }
			didAppearBefore = true
			action()
		}
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
