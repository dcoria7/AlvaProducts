//
//  Untitled.swift
//  ClickLocal
//
//  Created by DC on 21/10/24.
//

import Foundation
import SwiftUI

struct TranslucentButtonViewModifier: ViewModifier {
	
	func body(content: Content) -> some View {
		content
			.background(
				Color.white.opacity(0.1)
			)
			.cornerRadius(5)
	}
	
}

extension View {
	
	func translucentButtonStyle() -> some View {
		modifier(TranslucentButtonViewModifier())
	}
	
}

struct TranslucentButtonViewModifier_Previews: PreviewProvider {
	
	static var previews: some View {
		ZStack {
			HStack {
				Text("Cogeco Transparent Background")
				Spacer()
			}
			.foregroundColor(.white)
			.padding()
			.fillWidth()
			.translucentButtonStyle()
			.padding(.horizontal)
		}
	}
	
}

