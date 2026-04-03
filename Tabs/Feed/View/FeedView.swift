//
//  FeedView.swift
//
//

import SwiftUI
import FirebaseFirestore
import Firebase

struct FeedView: View {
    @State private var settingsTapped: Bool = false
	@State private var venueTapped: Bool = false
    @StateObject var viewModel = FeedViewModel()
    
    let user: User?
	var coordinator: AppCoordinator
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 24) {
                    ForEach(viewModel.posts) {post in
						FeedCell(post: post) {
//							coordinator.goToVenueDetail(userID: post.venue?.userId ?? "", venue: post.venue!)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
			.navigationBarColor(tintColor: UIColor.customBlack())
            .toolbar {
				ToolbarItem(placement: .principal) {
					Image(systemName: "house")
						
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button(action: {
						settingsTapped.toggle()
                    }) {
                        Image(systemName: "gear")
                            .imageScale(.large)
                    }
                }
            }
            .onAppear {
				Tracker.trackFeedEvent()
				
                Task {
					try await viewModel.fetchPosts()
                }
            }
			.refreshable {
				
				viewModel.posts = []
				viewModel.lastDocument = nil
				
				Task {
					try await viewModel.fetchPosts()
				}
			}
			.navigationDestination(isPresented: $settingsTapped) {
				AppSettingsView()
			}
//			.navigationDestination(isPresented: $venueTapped) {
//				
//			}
			.setDefaultBackgroundColor()
        }
        
    }
}

//struct FeedView_Previews: PreviewProvider {
//    static var previews: some View {
//		FeedView(user: User.mockUsers[0], coordinator: AppCoordinator())
//    }
//}
