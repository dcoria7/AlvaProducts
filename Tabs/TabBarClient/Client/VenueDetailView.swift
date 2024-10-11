//
//  VenueDetailView.swift
//  AlvaProducts
//
//  Created by Daniel Coria on 04/04/24.
//

import SwiftUI
import Kingfisher
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
			
			KFImage(URL(string: venue.imageURLString))
				.placeholder {
					ProgressView()
						.frame(width: 100)
				}
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(height: 210)
				.clipped()
				.padding(.top, 10)
			
			ProfileGeneralView(viewModel: viewModel)
		}
		.setDefaultBackgroundColor()
		.navigationBarTitleDisplayMode(.inline)
		.environmentObject(viewModel)
		.onAppear {
			print("DEBUG: Post count: \(viewModel.posts.count)")
			Task {
				try await viewModel.fetchUserPosts()
			}
		}
    }
}

