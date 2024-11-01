//
//  ProfileView.swift
//  AlvaProducts
//
//  Created by Daniel Coria on 04/04/24.
//

import SwiftUI
import Kingfisher
import FirebaseFirestore
import Firebase

struct ProfileView: View {
    @StateObject var viewModel = PostClientGridViewModel()

    let venue: Venue

    init(venue: Venue) {
        self.venue = venue
    }

    var body: some View {
		VStack {
			// header
			ProfileHeaderView(viewModel: viewModel)
			
			ScrollView {
				ProfileGeneralView(viewModel: viewModel)
				
				// post image
				KFImage(URL(string: viewModel.getMenuImage()))
					.placeholder {
						ProgressView()
							.frame(width: 100)
					}
					.resizable()
					.scaledToFit()
					.clipped() // Crop the image to the frame size
			}
		}
		.setDefaultBackgroundColor()
		.environmentObject(viewModel)
		.onAppear {
			Task {
//				try await viewModel.fetchUserPosts()
				try await viewModel.fetchVenue(userId: viewModel.user?.id ?? "")
				
				Tracker.trackProfileEvent(id: venue.id ?? "", name: venue.title)
			}
		}
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(venue: User.mockVenue[0])
    }
}
