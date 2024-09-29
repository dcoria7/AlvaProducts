//
//  AuthService.swift
//
//

import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift
import Foundation

class AuthService {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var currentVenue: Venue?

    static let shared = AuthService()

    init() {
        Task {
            try await loadUserData()
        }
    }

    @MainActor
    func login(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            userSession = result.user
            try await loadUserData()
        } catch {
            print("DEBUG: Failed to login user with error: \(error.localizedDescription)")
        }
    }

    @MainActor
    func createUser(email: String, password: String, username: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
//            userSession = result.user
            await uploadUserData(uid: result.user.uid, username: username, email: email)
            
        } catch {
            print("DEBUG: Failed to register user with error: \(error.localizedDescription)")
        }
    }

    @MainActor
    func loadUserData() async throws {
        do {
            userSession = Auth.auth().currentUser
            guard let currentUid = userSession?.uid else { return }
            currentVenue = try await UserService.fetchVenue(withUid: currentUid)
            currentUser = try await UserService.fetchUser(withUid: currentUid)
            
        } catch {
            print("error")
            signOut()
        }
    }
    
    @MainActor
    func loadCurrentUserData() async throws {
        do {
            
            guard let currentUid = userSession?.uid else { return }
            currentUser = try await UserService.fetchUser(withUid: currentUid)
        } catch {
            print("error")
            signOut()
        }
    }

    func signOut() {
        try? Auth.auth().signOut()
        userSession = nil
        currentUser = nil
    }

    private func uploadUserData(uid: String, username: String, email: String) async {
        let user = User(id: uid, username: username, email: email)
//        currentUser = user
        guard let encoded = try? Firestore.Encoder().encode(user) else { return }

        try? await Firestore.firestore().collection("users").document(user.id).setData(encoded)
        try? await loadCurrentUserData()
    }
}
