//
//  FeedView.swift
//  InstaSwift
//
//  Created by Bruno Rangel on 02/06/23.
//

import SwiftUI
import FirebaseFirestore

struct FeedView: View {
//    @Environment(\.colorScheme) var colorScheme
    @State private var profileTapped: Bool = false
    @State private var logoutTapped: Bool = false
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
                            if let user {
                                Task {
                                    try await viewModel.toggleLike(postId: post.id, uid: user.id)
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
			.navigationBarColor(tintColor: .white)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Alva")
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button(action: {
                        if user != nil {
                            logoutTapped.toggle()
                        } else {
                            profileTapped.toggle()
                        }
                    }) {
                        Image(systemName: "person")
                            .imageScale(.large)
                    }
                }
            }
            .onAppear {
                Task {
                    try await viewModel.fetchPosts()
                }
            }
			.refreshable {
				Task {
					try await viewModel.fetchPosts()
				}
			}
            .navigationDestination(isPresented: $profileTapped) {
                LoginView(user: user)
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
			.setDefaultBackgroundColor()
        }
        
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView(user: User.mockUsers[0])
    }
}
