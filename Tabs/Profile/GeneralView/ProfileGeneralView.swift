//
//  ProfileGeneralView.swift
//  AlvaProducts
//
//  Created by DC on 08/10/24.
//

import SwiftUI
import Kingfisher

struct ProfileGeneralView: View {
	
	@StateObject var viewModel: PostClientGridViewModel
	
    var body: some View {
		
			// post grid view
//			PostGridView(posts: viewModel.posts)
			
			
		VStack {
			Text(viewModel.description)
				.foregroundStyle(.white)
				.multilineTextAlignment(.leading)
				.frame(maxWidth: .infinity, alignment: .leading)
				.padding(.leading, 10)
				.padding(.top, 10)
				.font(.title3)
			
			HStack {
				makeBubble(text: "📞 3320302030") // TODO: make enum
				makeBubble(text: "🌐 @prueba")
			}
			.frame(maxWidth: .infinity, alignment: .center)
			.padding(.top, 10)
			
			HStack {
				makeBubble(text: "⏰ Horario Flexible")
				makeBubble(text: "🥗 Ensaladas")
			}
			.frame(maxWidth: .infinity, alignment: .center)
		}
		.padding(.top, 10)
    }
	
	@ViewBuilder
	private func makeBubble(text: String) -> some View {
		VStack {
			Text(text)
				.foregroundStyle(.white)
				.padding(.horizontal, 10)
				.padding(.vertical, 10)
		}
		.background(.clear)
		.frame(minHeight: 20, alignment: .leading)
		.overlay(
			Capsule(style: .continuous)
				.strokeBorder(Color.random(), lineWidth: 3)
		)
		
		
	}
}
