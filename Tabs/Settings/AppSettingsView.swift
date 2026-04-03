//
//  AppSettingsView.swift
//  ClickLocal
//
//  Created by DC on 21/10/24.
//

import SwiftUI

struct AppSettingsView: View {
	@StateObject var viewModel = AppSettingsViewModel()
	@State private var showLogoutDialog: Bool = false
	@State private var loginTapped: Bool = false
	@State private var showPhoneOptions = false
	
	// TODO: Localize
	let alertTitle: String = "Cerrar sesión?"
	
	var body: some View {
		ScrollView {
			
			Group {
				Button(action: {
					showPhoneOptions.toggle()
				}) {
					customView(title: "¡Contáctanos!")
				}
				
				Button(action: {
					if viewModel.getUser() != nil {
						showLogoutDialog.toggle()
					} else {
						loginTapped.toggle()
					}
				}) {
					if viewModel.getUser() != nil {
						customView(title: "Cerrar sesión")
					} else {
						customView(title: "Iniciar sesión")
					}
				}
				
				Text("Version 1.0")
					.foregroundStyle(Color.customWhite())
					.padding(.top, 10)
			}
			.padding()
		}
		.setBlackBackgroundColor()
		.navigationDestination(isPresented: $loginTapped) {
			LoginView(user: viewModel.getUser())
		}
		.alert(
			alertTitle,
			isPresented: $showLogoutDialog
		) {
			Button(role: .destructive) {
				AuthService.shared.signOut()
			} label: {
				Text("Logout")
			}
			Button(role: .cancel) { } label: {
				Text("Cancelar")
			}
		}
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
	}
	
	@ViewBuilder
	private func customView(title: String) -> some View {
		HStack {
			VStack(alignment: .leading, spacing: 2) {
				Text(title) // TODO: Localize
					.font(.title3)
					.foregroundStyle(Color.customWhite())
			}
			Spacer()
		}
		.foregroundColor(.white)
		.padding()
		.translucentButtonStyle()
	}
		
}

#Preview {
	AppSettingsView()
}
