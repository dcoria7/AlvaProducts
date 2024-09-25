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
    
    let user: User?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 24) {
                    ForEach(viewModel.posts) {post in
                        FeedCell(post: post, user: user) {
                            if let user {
                                Task {
                                    try await viewModel.toggleLike(postId: post.id, uid: user.id)
                                }
                            }
                        }
                    }
                }
                .padding(.top, 8)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image("instagram-black")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
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
            .navigationDestination(isPresented: $profileTapped) {
                LoginView(user: user)
            }
            .alert("Cerrar Sesión?", isPresented: $logoutTapped) {
                Button("OK", role: .cancel) {
                    AuthService.shared.signOut()
                }
                Button("Cancelar", role: .destructive) { }
            }
            .background(Color.gray)
        }
        
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView(user: User.mockUsers[0])
    }
}
