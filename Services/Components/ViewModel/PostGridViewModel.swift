//
//  PostGridViewModel.swift
//
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
    func fetchUserPosts() async throws {
        if !isDataFetched {
            self.posts = try await PostService.fetchUserPosts(uid: user.id)
            isDataFetched = true
        }
    }
}

class PostClientGridViewModel: ObservableObject {
	let userId: String
	let venue: Venue
	
	@Published var posts = [Post]()
	var isDataFetched = false
	
	var postsCount: Int {
		posts.count
	}
	
	init(userId: String, venue: Venue) {
		self.userId = userId
		self.venue = venue
	}
	
	@MainActor
	func fetchUserPosts() async throws {
		if !isDataFetched {
			self.posts = try await PostService.fetchUserPosts(uid: userId)
			isDataFetched = true
		}
	}
}
