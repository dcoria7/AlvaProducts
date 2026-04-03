//
//  CurrentUserProfileView.swift
//  ClickLocal
//
//  Created by Daniel Coria on 04/04/24.
//

import SwiftUI

struct CurrentUserProfileView: View {
	let user: User
	let venue: Venue
	
	@State private var settingsTapped: Bool = false
	
	// TODO: Localize
	let alertTitle: String = "Cerrar sesión?"
	
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
		}
		.setDefaultBackgroundColor()
	}
}

struct CurrentUserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentUserProfileView(user: User.mockUsers.first!, venue: User.mockVenue.first!)
    }
}
