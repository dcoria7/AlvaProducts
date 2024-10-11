//
//  PostGridViewModel.swift
//
//

import Foundation
import SwiftUI

class PostGridViewModel: ObservableObject {
    let user: User
    let venue: Venue
    
	@Published var isActive: Bool = false
    @Published var posts = [Post]()
    var isDataFetched = false

    var postsCount: Int {
        posts.count
    }

    init(user: User, venue: Venue) {
        self.user = user
        self.venue = venue
		
		isActive = venue.active
    }
	
	func getMenuImage() -> String {
		guard let image = venue.menuImage else {
			return ""
		}
		return image
	}
	
	func getVenueDescription() -> String {
		guard let image = venue.venueDescription else {
			return ""
		}
		return image
	}

    @MainActor
    func fetchUserPosts() async throws {
        if !isDataFetched {
            self.posts = try await PostService.fetchUserPosts(uid: user.id)
            isDataFetched = true
        }
    }
	
	@MainActor
	func updateVenueStatus(newValue: Bool) async throws {
		UserService.updateVenueActive(userID: user.id, newValue: newValue)
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
	
	func getVenueDescription() -> String {
		guard let image = venue.venueDescription else {
			return ""
		}
		return image
	}
	
	func getMenuImage() -> String {
		guard let image = venue.menuImage else {
			return ""
		}
		return image
	}
	
	@MainActor
	func fetchUserPosts() async throws {
		if !isDataFetched {
			self.posts = try await PostService.fetchUserPosts(uid: userId)
			isDataFetched = true
		}
	}
}
