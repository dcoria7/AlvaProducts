//
//  UserService.swift
//  InstaSwift
//
//  Created by Bruno Rangel on 06/06/23.
//

import Firebase
import Foundation
import FirebaseFirestore

struct UserService {
    static func fetchAllUsers() async throws -> [User] {
        let snapshot = try await Firestore.firestore().collection("users").getDocuments()
        let documents = snapshot.documents
        return documents.compactMap({ try? $0.data(as: User.self) })
    }
    
    static func fetchUser(withUid uid: String) async throws -> User {
        let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
        return try snapshot.data(as: User.self)
    }
    
    static func fetchVenue(withUid userId: String) async throws -> Venue? {
        let venuesCollection = Firestore.firestore().collection("venues")
        
        let snapshot = try await venuesCollection.whereField("userId", isEqualTo: userId).getDocuments()
        return snapshot.documents.compactMap({ try? $0.data(as: Venue.self) }).first
    }
}
