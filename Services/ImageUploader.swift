//
//  ImageUploader.swift
//  ClickLocal
//
//  Created by Daniel Coria on 04/04/24.
//

import Firebase
import FirebaseStorage
import UIKit

enum ImageType: String {
    case post = "profile_post"
    case products = "profile_products"
}

struct ImageUploader {
    static func uploadImage(type: ImageType, image: UIImage) async throws -> String? {
        guard let image = image.jpegData(compressionQuality: 0.5) else { return nil }
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "\(type)\(filename)")

        do {
            let _ = try await ref.putDataAsync(image)
            let url = try await ref.downloadURL()
            return url.absoluteString
        } catch {
            print("DEBUG: Failed to upload image with error \(error.localizedDescription)")
            return nil
        }
    }
}
