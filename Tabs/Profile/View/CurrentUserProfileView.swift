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
    
    var body: some View {
        NavigationStack {
            ProfileView(user: user, venue: venue)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            AuthService.shared.signOut()
                        } label: {
                            Image(systemName: "line.3.horizontal")
                                .foregroundColor(.primary)
                        }
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
