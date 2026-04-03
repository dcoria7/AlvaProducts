//
//  PostGridViewModel.swift
//
//

import Foundation
import SwiftUI

//class PostGridViewModel: ObservableObject {
//    let user: User
//    let venue: Venue
//    
//	@Published var isActive: Bool = false
//    @Published var posts = [Post]()
//    var isDataFetched = false
//
//    var postsCount: Int {
//        posts.count
//    }
//
//    init(user: User, venue: Venue) {
//        self.user = user
//        self.venue = venue
//		
//		isActive = venue.active
//    }
//	
//	func getMenuImage() -> String {
//		guard let image = venue.menuImage else {
//			return ""
//		}
//		return image
//	}
//	
//	func getVenueDescription() -> String {
//		guard let image = venue.venueDescription else {
//			return ""
//		}
//		return image
//	}
//
//    @MainActor
//    func fetchUserPosts() async throws {
//        if !isDataFetched {
//            self.posts = try await PostService.fetchUserPosts(uid: user.id)
//            isDataFetched = true
//        }
//    }
//	
//	@MainActor
//	func updateVenueStatus(newValue: Bool) async throws {
//		UserService.updateVenueActive(userID: user.id, newValue: newValue)
//	}
//}

class PostClientGridViewModel: ObservableObject {
	
	private let service = AuthService.shared
	var userId: String = ""
	var user: User? = nil
	var venue: Venue? = nil
	var isDataFetched = false
	
	@Published var menuImage = ""
	@Published var title = ""
	@Published var description = ""
	@Published var posts = [Post]()
	@Published var isActive: Bool = false
	
	var tags: [String] = []
	
	var phone: String {
		venue?.phone ?? ""
	}
	
	var network: String {
		venue?.network ?? ""
	}
	
	var schedule: String {
		venue?.schedule ?? ""
	}
	
	var type: String {
		venue?.typeOfVenue ?? ""
	}
	
	var postsCount: Int {
		posts.count
	}
	
	init() {
		self.user = service.currentUser
		self.userId = user?.id ?? ""
	}
	
//	init(userId: String, venue: Venue) {
//		self.userId = userId
//		self.venue = venue
//		self.user = service.currentUser
//	}
	
	func getCurrentUser() -> User {
		self.user ?? service.currentUser!
	}
	
	private func getVenueTitle() -> String {
		guard let title = venue?.title else {
			return ""
		}
		return title
	}
	
	private func getVenueDescription() -> String {
		guard let desc = venue?.venueDescription else {
			return ""
		}
		return desc
	}
	
	func getMenuImage() -> String {
		guard let image = venue?.menuImage else {
			return ""
		}
		return image
	}
	
	func getBubbleColor(iconText: String) -> Color {
		if iconText.contains("📞") {
			return .red
		} else if iconText.contains("🌐") {
			return .blue
		} else if iconText.contains("⏰") {
			return .purple
		} else {
			return .yellow
		}
		
	}
	
	@MainActor
	func fetchUserPosts() async throws {
		if !isDataFetched {
			self.posts = try await PostService.fetchUserPosts(uid: userId)
			isDataFetched = true
		}
	}
	
	@MainActor
	func updateVenueStatus(newValue: Bool) async throws {
		UserService.updateVenueActive(userID: userId, newValue: newValue)
	}
	
	@MainActor
	func fetchVenue(userId: String) async throws {
		do {
			tags = []
			self.venue = try await UserService.fetchVenue(withId: userId)
			self.menuImage = getMenuImage()
			self.title = getVenueTitle()
			self.description = getVenueDescription()
			guard let isActive = self.venue?.active else { return }
			self.isActive = isActive
			
			if !phone.isEmpty {
				tags.append("📞 \(phone)")
			}
			
			if !network.isEmpty {
				tags.append("🌐 \(network)")
			}
			
			if !schedule.isEmpty {
				tags.append("⏰ \(schedule)")
			}
			
			if !type.isEmpty {
				tags.append("\(type)")
			}
			
		} catch {
			print("handle error")
		}
	}
}
