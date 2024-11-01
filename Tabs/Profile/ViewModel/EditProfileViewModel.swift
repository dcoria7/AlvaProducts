//
//  EditProfileViewModel.swift
//  InstaSwift
//
//  Created by Bruno Rangel on 06/06/23.
//

import Firebase
import PhotosUI
import SwiftUI
import FirebaseFirestore

class EditProfileViewModel: ObservableObject {
    @Published var user: User
	@Published var venue: Venue?
    @Published var selectedImage: PhotosPickerItem? {
        didSet {
            Task {
                await loadImage(fromItem: selectedImage)
            }
        }
    }
	
	@Published var selectedMenuImage: PhotosPickerItem? {
		didSet {
			Task {
				await loadMenuImage(fromItem: selectedMenuImage)
			}
		}
	}

    @Published var profileImage: Image?
	@Published var menuImage: Image?
    @Published var venueTitle = ""
	@Published var userEmail = ""
	@Published var venueDescription = ""
	@Published var venuePhone = ""
	@Published var venueSchedule = ""
	@Published var venueNetwork = ""
	@Published var venueType = ""

    private var uiImage: UIImage?
	private var uiMenuImage: UIImage?

	init(user: User, venue: Venue?) {
        self.user = user
		self.venue = venue
		
		if let venue = venue {
			venueTitle = venue.title
			venueDescription = venue.venueDescription ?? ""
			venuePhone = venue.phone
			venueSchedule = venue.schedule
			venueNetwork = venue.network ?? ""
			venueType = venue.typeOfVenue
		}
    }

    @MainActor
    func loadImage(fromItem item: PhotosPickerItem?) async {
        guard let item = item else { return }

        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.uiImage = uiImage
        profileImage = Image(uiImage: uiImage)
    }
	
	@MainActor
	func loadMenuImage(fromItem item: PhotosPickerItem?) async {
		guard let item = item else { return }
		
		guard let data = try? await item.loadTransferable(type: Data.self) else { return }
		guard let uiImage = UIImage(data: data) else { return }
		self.uiMenuImage = uiImage
		menuImage = Image(uiImage: uiImage)
	}

	func updateUserData() async throws {
		var data = [String: Any]()
		
		//update profile image if changed
		if let uiImage = uiImage {
			let imageUrl = try await ImageUploader.uploadImage(type: .post, image: uiImage)
			data["imageURLString"] = imageUrl
		}
		
		// update title if changed
		if venue?.title != venueTitle {
			venue?.title = venueTitle
			data["title"] = venueTitle
		}
		
		// update description if changed
		if venue?.venueDescription != venueDescription {
			venue?.venueDescription = venueDescription
			data["venueDescription"] = venueDescription
		}
		
		// update phone if changed
		if venue?.phone != venuePhone {
			venue?.phone = venuePhone
			data["phone"] = venuePhone
		}
		
		// update schedule if changed
		if venue?.schedule != venueSchedule {
			venue?.schedule = venueSchedule
			data["schedule"] = venueSchedule
		}

		// update network if changed
		if venue?.network != venueNetwork {
			venue?.network = venueNetwork
			data["network"] = venueNetwork
		}
		
		// update type if changed
		if venue?.typeOfVenue != venueType {
			venue?.typeOfVenue = venueType
			data["typeOfVenue"] = venueType
		}
		
		//update profile image if changed
		if let uiImage = uiMenuImage {
			let imageUrl = try await ImageUploader.uploadImage(type: .post, image: uiImage)
			data["menuImage"] = imageUrl
		}
		
		updateData(data: data)
		try await AuthService.shared.loadUserData()
	}
	
	func updateData(data: [String: Any]) {
		if !data.isEmpty {
			let venue = Firestore.firestore().collection("venues")
			
			venue.whereField("userId", isEqualTo: user.id).getDocuments { (result, error) in
				if error == nil {
					result?.documents.first?.reference.updateData(data)
				} else {
					print("error update user data: \(error.debugDescription)")
				}
			}
		}
	}
}
