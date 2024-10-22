//
//  AppSettingsViewModel.swift
//  AlvaProducts
//
//  Created by DC on 21/10/24.
//

import SwiftUI

class AppSettingsViewModel: ObservableObject {
	
	private let service = AuthService.shared
	
	func getUser() -> User? {
		service.currentUser
	}
	
}
