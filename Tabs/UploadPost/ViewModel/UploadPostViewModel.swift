//
//  UploadPostViewModel.swift
//  ClickLocal
//
//  Created by Daniel Coria on 04/04/24.
//

import Firebase
import PhotosUI
import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import Combine

class UploadPostViewModel: ObservableObject {
    @Published var selectedImage: PhotosPickerItem? {
        didSet {
            Task {
                await loadImage(fromItem: selectedImage)
            }
        }
    }
    
	@Published var isPostButtonDisabled: Bool = true
    @Published var postImage: Image? = nil
    @Published var caption = ""
    
    private var uiImage: UIImage?
	
	init() {
		
		// Binding
		Publishers
			.CombineLatest(
				$caption,
				$postImage
			)
			.map { caption, postImage in
				caption.isEmptyOrWhitespace() && postImage != nil
			}
			.assign(to: &$isPostButtonDisabled)
	}
    
    @MainActor
    func loadImage(fromItem item: PhotosPickerItem?) async {
        guard let item = item else { return }
        
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.uiImage = uiImage
        self.postImage = Image(uiImage: uiImage)
    }
    
    func uploadPost(caption: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let currentVenue = AuthService.shared.currentVenue else { return }
        guard let uiImage = self.uiImage else { return }
        
        let postRef = Firestore.firestore().collection("posts").document()
        guard let imageUrl = try await ImageUploader.uploadImage(type: .post, image: uiImage) else { return }
        
        let post = Post(id: postRef.documentID, ownerUid: uid, caption: caption, likes: 0, imageUrl: imageUrl, timestamp: Timestamp(), venue: currentVenue)
        
        guard let encodedPost = try? Firestore.Encoder().encode(post) else { return }
//		do {
			try await postRef.setData(encodedPost)
//			return true
//		} catch {
//			return false
//		}
    }
}
