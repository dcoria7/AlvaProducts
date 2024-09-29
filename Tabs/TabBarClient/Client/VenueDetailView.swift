//
//  VenueDetailView.swift
//  AlvaProducts
//
//  Created by Daniel Coria on 04/04/24.
//

import SwiftUI
import FirebaseFirestore

struct VenueDetailView: View {
    var venue: Venue
	var userId: String
	@StateObject var viewModel: PostClientGridViewModel
	
	init(userId: String, venue: Venue) {
		self.userId = userId
		self.venue = venue
		_viewModel = StateObject(wrappedValue: PostClientGridViewModel(userId: userId, venue: venue))
	}
    
    var body: some View {
        VStack {
			PostGridView(posts: viewModel.posts)
			
			Spacer()
			Text("Menu here")
		}
		.navigationBarTitleDisplayMode(.inline)
		.navigationTitle("\(venue.title) ")
		.environmentObject(viewModel)
		.onAppear {
			print("DEBUG: Post count: \(viewModel.posts.count)")
			Task {
				try await viewModel.fetchUserPosts()
			}
		}
    }
}

