//
//  VenueDetailView.swift
//  AlvaProducts
//
//  Created by Daniel Coria on 04/04/24.
//

import SwiftUI
import Kingfisher
import FirebaseFirestore
import Firebase

struct VenueDetailView: View {
    var venue: Venue
	var userId: String
	@StateObject var viewModel = PostClientGridViewModel()
	
	init(userId: String, venue: Venue) {
		self.userId = userId
		self.venue = venue
//		_viewModel = StateObject(wrappedValue: PostClientGridViewModel(userId: userId, venue: venue))
	}
    
    var body: some View {
		ScrollView {
			VStack {
				HStack {
					KFImage(URL(string: venue.imageURLString))
						.placeholder {
							ProgressView()
								.frame(width: 100)
						}
						.resizable()
						.scaledToFit()
						.frame(height: 100)
						.clipped() // Crop the image to the frame size
						.cornerRadius(10)
						.padding(.leading, 10)
					
					ProfileGeneralView(viewModel: viewModel)
				}
				
				// post image
				KFImage(URL(string: viewModel.menuImage))
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
		.navigationBarTitleDisplayMode(.inline)
		.environmentObject(viewModel)
		.onAppear {
			
			Task {
//				try await viewModel.fetchUserPosts()
				try await viewModel.fetchVenue(userId: userId)
				
				Tracker.trackVenueDetailEvent(id: userId, name: venue.title)
			}
		}
    }
}

