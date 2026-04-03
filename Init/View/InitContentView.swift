//
//  InitContentView.swift
//
//

import SwiftUI

struct InitContentView: View {
	@StateObject var viewModel = ContentViewModel()
	// ObservedObject to listen to changes in the coordinator
	@ObservedObject var coordinator: AppCoordinator
	
	var body: some View {
		Group {
			// Start the coordinator to determine which view to display
			if viewModel.userSession == nil {
				coordinator.start(contentViewModel: viewModel, user: nil, venue: nil)
					.accessibilityElement(children: .contain) // Ensures the contained views are accessible
				
			} else if let currentUser = viewModel.currentUser,
					  let currentVenue = viewModel.currentVenue {
				coordinator.start(contentViewModel: viewModel, user: currentUser, venue: currentVenue)
					.accessibilityElement(children: .contain) // Ensures the contained views are accessible
			}
		}
	}
}
