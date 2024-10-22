//
//  AppSettingsView.swift
//  AlvaProducts
//
//  Created by DC on 21/10/24.
//

import SwiftUI

struct AppSettingsView: View {
	@StateObject var viewModel = AppSettingsViewModel()
	@State var showLogoutDialog: Bool = false
	
	// TODO: Localize
	let alertTitle: String = "Cerrar Sesión?"
	
	var body: some View {
		ScrollView {
			
			Group {
				Button(action: {
					
				}) {
					customView(title: "Algo mas...")
				}
				
				Button(action: {
					if viewModel.getUser() != nil {
						showLogoutDialog.toggle()
					} else {
						showLogoutDialog.toggle()
					}
				}) {
					customView(title: "Cerrar Sesión")
				}
				
				Text("Version 1.0")
					.foregroundStyle(Color.customWhite())
					.padding(.top, 10)
			}
			.padding()
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
		.setBlackBackgroundColor()
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
