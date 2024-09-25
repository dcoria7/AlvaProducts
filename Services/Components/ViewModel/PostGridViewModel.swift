//
//  PostGridViewModel.swift
//  InstaSwift
//
//  Created by Bruno Rangel on 06/06/23.
//

import Foundation

class PostGridViewModel: ObservableObject {
    let user: User
    let venue: Venue
    
    @Published var posts = [Post]()
    var isDataFetched = false

    var postsCount: Int {
        posts.count
    }

    init(user: User, venue: Venue) {
        self.user = user
        self.venue = venue
    }

    @MainActor
    func fetchUserPosts(posts: [Post]) async throws {
        if !isDataFetched {
            self.posts = try await PostService.fetchUserPosts(collectionPosts: posts, uid: user.id)
            isDataFetched = true
        }
    }
}
