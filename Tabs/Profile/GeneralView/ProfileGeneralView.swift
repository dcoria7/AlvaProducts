//
//  ProfileGeneralView.swift
//  AlvaProducts
//
//  Created by DC on 08/10/24.
//

import SwiftUI
import Kingfisher
import WrappingHStack

struct ProfileGeneralView: View {
	
	@StateObject var viewModel: PostClientGridViewModel
	@State private var showingPhoneOptions = false
	
	// TODO: Localize
	let alertTitle: String = ""
	
    var body: some View {
		
			// post grid view
//			PostGridView(posts: viewModel.posts)
			
			
		VStack {
			Text(viewModel.description)
				.foregroundStyle(Color.customBlack())
				.multilineTextAlignment(.leading)
				.frame(maxWidth: .infinity, alignment: .leading)
				.padding(.leading, 10)
				.padding(.top, 10)
				.font(.title3)
			
			WrappingHStack(viewModel.tags, id:\.self, alignment: .center) {
				makeBubble(text: $0)
					.padding(.top, 10)
			}
			.frame(minWidth: 250, alignment: .center)
			
//			HStack {
//				makeBubble(text: "📞 \(viewModel.phone)") // TODO: make enum
//					.onTapGesture {
//						showingPhoneOptions.toggle()
//					}
//				
//				makeBubble(text: "🌐 @\(viewModel.network)")
//			}
//			.frame(maxWidth: .infinity, alignment: .center)
//			.padding(.top, 10)
//			
//			HStack {
//				makeBubble(text: "⏰ \(viewModel.schedule)")
//				makeBubble(text: "🥗 \(viewModel.type)")
//			}
//			.frame(maxWidth: .infinity, alignment: .center)
		}
		.padding(.top, 10)
		.confirmationDialog(alertTitle, isPresented: $showingPhoneOptions) {
			Button() {
				AuthService.shared.signOut()
			} label: {
				Text("Copiar")
			}
			Button() {
				guard let phoneNum = URL(string: "tel://\(viewModel.phone)") else {return}
				UIApplication.shared.open(phoneNum)
			} label: {
				Text("Llamar")
			}
		}
    }
	
	@ViewBuilder
	private func makeBubble(text: String) -> some View {
		Text(text)
			.foregroundStyle(Color.customBlack())
			.padding(.horizontal, 10)
			.padding(.vertical, 10)
			.background(
				Capsule()
					.strokeBorder(Color.random(),lineWidth: 3)
					.background(.clear)
					.clipped()
			)
			.onTapGesture {
				if text.contains("📞") {
					showingPhoneOptions.toggle()
				}
			}
	}
}
