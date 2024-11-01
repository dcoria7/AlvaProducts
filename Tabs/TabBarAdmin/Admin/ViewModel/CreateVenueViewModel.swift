//
//  CreateVenueViewModel.swift
//  AlvaProducts
//
//  Created by Daniel Coria on 04/04/24.
//

import SwiftUI
import Combine
import FirebaseFirestore
import Firebase
import PhotosUI
import FirebaseAuth

class CreateVenueViewModel: ObservableObject {
    
    // Reference to Firestore
    let db = Firestore.firestore()
    
    @Published var venueName: String = ""
	@Published var venueDescription: String = ""
	@Published var venuePhone: String = ""
	@Published var venueNetwork: String = ""
	@Published var venueSchedule: String = ""
	@Published var venueType: String = ""
    @Published var isSaveDisable: Bool = true
    
    // private
    private var bag = Set<AnyCancellable>()
    
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
    
    @Published var postImage: Image?
    @Published var menuImage: Image?
    
    private var uiImage: UIImage?
    private var menuUIImage: UIImage?
    
    init() {
        $venueName
            .receiveOnMain()
            .sink { name in
                self.isSaveDisable = name.isEmpty
            }
            .store(in: &bag)
    }
    
    @MainActor
    func loadImage(fromItem item: PhotosPickerItem?) async {
        guard let item = item else { return }
        
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.uiImage = uiImage
        self.postImage = Image(uiImage: uiImage)
    }
    
    func loadMenuImage(fromItem item: PhotosPickerItem?) async {
        guard let item = item else { return }
        
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.menuUIImage = uiImage
        self.menuImage = Image(uiImage: uiImage)
    }
    
	func uploadVenueImage(title: String, description: String, userID: String, phone: String, network: String, schedule: String, typeOfVenue: String) async throws {
        guard let userImage = self.uiImage else { return }
        guard let menuImage = self.menuUIImage else { return }
        
        let postRef = db.collection("venues").document()
        guard let userImageUrl = try await ImageUploader.uploadImage(type: .post, image: userImage) else { return }
        guard let menuImageUrl = try await ImageUploader.uploadImage(type: .post, image: menuImage) else { return }
        
		let venue = Venue(id: postRef.documentID,
						  title: title,
						  imageURLString: userImageUrl,
						  available: false,
						  date: Date(),
						  active: false,
						  userId: userID,
						  venueDescription: description,
						  menuImage: menuImageUrl,
						  phone: phone,
						  network: network,
						  schedule: schedule,
						  typeOfVenue: typeOfVenue
		)
        
//        let post = Post(id: postRef.documentID, ownerUid: uid, caption: caption, likes: 0, imageUrl: imageUrl, timestamp: Timestamp())
        
        guard let encodedPost = try? Firestore.Encoder().encode(venue) else { return }
        try await postRef.setData(encodedPost)
    }
    
	func insertVenue(title: String, description: String, userID: String, phone: String, network: String, schedule: String, typeOfVenue: String) {
        // Create a document in the venues collection
//        db.collection("venues").addDocument(data: [
//            "title": title,
//            "available": false,
//            "date": Date(),
//            "imageURLString": "",
//            "active": false,
//            "userId": userID,
//            "venueDescription": "",
//            "menuImage": ""
//        ])
        
        Task {
			do {
				try await uploadVenueImage(title: title, description: description, userID: userID, phone: phone, network: network, schedule: schedule, typeOfVenue: typeOfVenue)
			} catch {
				print("handle error")
			}
			
        }
        
        print("----- venue created done")
    }

}

struct Venue: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var title: String
    var imageURLString: String = ""
    var available: Bool
    var date: Date
    var active: Bool
    var userId: String?
    var venueDescription: String?
    var menuImage: String?
	var phone: String
	var network: String?
	var schedule: String
	var typeOfVenue: String
}


