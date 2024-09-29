//
//  CurrentUserProfileView.swift
//  InstaSwift
//
//  Created by Bruno Rangel on 03/06/23.
//

import SwiftUI

struct CurrentUserProfileView: View {
	let user: User
	let venue: Venue
	
	@State private var logoutTapped: Bool = false
	
	// TODO: Localize
	let alertTitle: String = "Cerrar Sesión?"
	
	var body: some View {
		NavigationStack {
			ProfileView(user: user, venue: venue)
				.toolbar {
					ToolbarItem(placement: .navigationBarTrailing) {
						Button {
							logoutTapped.toggle()
						} label: {
							Image(systemName: "person")
								.imageScale(.large)
						}
					}
				}
				.alert(
					alertTitle,
					isPresented: $logoutTapped
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
		}
	}
}

struct CurrentUserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentUserProfileView(user: User.mockUsers.first!, venue: User.mockVenue.first!)
    }
}
