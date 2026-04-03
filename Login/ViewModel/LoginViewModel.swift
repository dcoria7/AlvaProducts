//
//  LoginViewModel.swift
//  ClickLocal
//
//  Created by Daniel Coria on 04/04/24.
//

import Foundation

class LoginViewModel: ObservableObject {
	
	@Published var showCompleteInputDialog: Bool = false
	@Published var showForgotPasswordDialog: Bool = false
	
    @Published var email = ""
    @Published var password = ""
    
	@MainActor
	func signIn() async throws {
//		do {
			try await AuthService.shared.login(withEmail: email, password: password)
//		} catch {
//			showCompleteInputDialog = true
//		}
    }
}
