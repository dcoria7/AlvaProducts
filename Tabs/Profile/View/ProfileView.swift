//
//  ProfileView.swift
//  InstaSwift
//
//  Created by Bruno Rangel on 02/06/23.
//

import SwiftUI
import FirebaseFirestore

struct ProfileView: View {
    @StateObject var viewModel: PostGridViewModel
    @FirestoreQuery(collectionPath: "posts") var postsCollection: [Post]

    let user: User
    let venue: Venue

    init(user: User, venue: Venue) {
        self.user = user
        self.venue = venue
        _viewModel = StateObject(wrappedValue: PostGridViewModel(user: user, venue: venue))
    }

    var body: some View {
        ScrollView {
            // header
            ProfileHeaderView()
            // post grid view
            PostGridView(posts: postsCollection)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("\(self.user.username) - \(venue.title) ")
        .refreshable {
            Task {
                try await viewModel.fetchUserPosts(posts: postsCollection)
            }
        }
        .environmentObject(viewModel)
        .onAppear {
            print("DEBUG: Post count: \(viewModel.posts.count)")
            Task {
                try await viewModel.fetchUserPosts(posts: postsCollection)
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: User.mockUsers[1], venue: User.mockVenue[0])
    }
}
