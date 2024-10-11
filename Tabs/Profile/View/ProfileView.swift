//
//  ProfileView.swift
//  AlvaProducts
//
//  Created by Daniel Coria on 04/04/24.
//

import SwiftUI
import Kingfisher
import FirebaseFirestore

struct ProfileView: View {
    @StateObject var viewModel: PostClientGridViewModel

    let user: User
    let venue: Venue

    init(user: User, venue: Venue) {
        self.user = user
        self.venue = venue
		_viewModel = StateObject(wrappedValue: PostClientGridViewModel(userId: user.id, venue: venue))
    }

    var body: some View {
		VStack {
			// header
			ProfileHeaderView(viewModel: PostGridViewModel(user: user, venue: venue))
			
			ProfileGeneralView(viewModel: viewModel)
		}
		.setDefaultBackgroundColor()
		.environmentObject(viewModel)
		.onAppear {
			print("DEBUG: Post count: \(viewModel.posts.count)")
			Task {
				try await viewModel.fetchUserPosts()
			}
		}
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: User.mockUsers[1], venue: User.mockVenue[0])
    }
}
