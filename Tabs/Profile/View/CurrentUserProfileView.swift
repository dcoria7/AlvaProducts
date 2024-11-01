//
//  CurrentUserProfileView.swift
//  InstaSwift
//
//

import SwiftUI

struct CurrentUserProfileView: View {
	let user: User
	let venue: Venue
	
	@State private var settingsTapped: Bool = false
	
	// TODO: Localize
	let alertTitle: String = "Cerrar Sesión?"
	
	var body: some View {
		NavigationStack {
			ProfileView(venue: venue)
				.toolbar {
					ToolbarItem(placement: .navigationBarTrailing) {
						Button {
							settingsTapped.toggle()
						} label: {
							Image(systemName: "gear")
								.imageScale(.large)
						}
					}
				}
				.navigationDestination(isPresented: $settingsTapped) {
					AppSettingsView()
				}
//				.alert(
//					alertTitle,
//					isPresented: $logoutTapped
//				) {
//					Button(role: .destructive) {
//						AuthService.shared.signOut()
//					} label: {
//						Text("Logout")
//					}
//					Button(role: .cancel) { } label: {
//						Text("Cancelar")
//					}
//				}
		}
		.setDefaultBackgroundColor()
	}
}

struct CurrentUserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentUserProfileView(user: User.mockUsers.first!, venue: User.mockVenue.first!)
    }
}
