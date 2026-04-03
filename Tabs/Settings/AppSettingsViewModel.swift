//
//  AppSettingsViewModel.swift
//  ClickLocal
//
//  Created by DC on 21/10/24.
//

import SwiftUI

class AppSettingsViewModel: ObservableObject {
	
	private let service = AuthService.shared
	
	var phone: String {
		"33-1405-0169"
	}
	
	func getUser() -> User? {
		service.currentUser
	}
	
}
