//
//  ProfileGeneralView.swift
//  ClickLocal
//
//  Created by DC on 08/10/24.
//

import SwiftUI
import Kingfisher
import WrappingHStack

struct ProfileGeneralView: View {
	
	@StateObject var viewModel: PostClientGridViewModel
	@State private var showPhoneOptions = false
	@State private var showNetworkOption = false
	
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
			
		}
		.padding(.top, 10)
		.confirmationDialog(alertTitle, isPresented: $showPhoneOptions) {
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
			
			Button() {
				if let url = URL(string: "https://wa.me/+52\(viewModel.phone)?text=Hello"),
				   UIApplication.shared.canOpenURL(url) {
					UIApplication.shared.open(url, options: [:])
				}
			} label: {
				Text("Abrir en WhatsApp") //TODO: Localize
			}
		}
		.confirmationDialog(alertTitle, isPresented: $showNetworkOption) {
			Button() {
				guard let instagram = URL(string: "https://www.instagram.com/\(viewModel.network)") else { return }
				UIApplication.shared.open(instagram)
			} label: {
				Text("Abrir Instagram")
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
					.strokeBorder(viewModel.getBubbleColor(iconText: text), lineWidth: 3)
					.background(.clear)
					.clipped()
			)
			.onTapGesture {
				if text.contains("📞") {
					showPhoneOptions.toggle()
				}
				if text.contains("🌐") {
					showNetworkOption.toggle()
				}
			}
	}
}
