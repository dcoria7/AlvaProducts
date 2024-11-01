//
//  FeedView.swift
//  InstaSwift
//
//  Created by Bruno Rangel on 02/06/23.
//

import SwiftUI
import FirebaseFirestore
import Firebase

struct FeedView: View {
    @State private var settingsTapped: Bool = false
    @StateObject var viewModel = FeedViewModel()
	
	// TODO: Localize
	let alertTitle: String = "Cerrar Sesión?"
    
    let user: User?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 24) {
                    ForEach(viewModel.posts) {post in
                        FeedCell(post: post) {
//                            if let user {
//                                Task {
//                                    try await viewModel.toggleLike(postId: post.id, uid: user.id)
//                                }
//                            }
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
			.navigationBarColor(tintColor: UIColor.customBlack())
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Alva")
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
			.setDefaultBackgroundColor()
        }
        
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView(user: User.mockUsers[0])
    }
}
