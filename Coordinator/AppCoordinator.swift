//
//  AppCoordinator.swift
//  MilleanaApp
//
//  Created by DC on 04/11/24.
//

import SwiftUI

// AppCoordinator class that manages navigation and view presentation
class AppCoordinator: ObservableObject, Coordinator {
	
	// Published property to update the current view
	@Published var currentView: AnyView?
	@EnvironmentObject var appCoordinator: AppCoordinatorImpl
	
	func start(contentViewModel: ContentViewModel, user: User?, venue: Venue?) -> some View {
		MainTabView(user: user, venue: venue, coordinator: self)
			.environmentObject(contentViewModel)
	}
	
	
	func goToVenueDetail(userID: String, venue: Venue) {
//		self.currentView = AnyView(
//		VenueDetailView(userId: userID, venue: venue) // TODO: use coordinator instead
//		)
		appCoordinator.push(.home)
	}
//	// Function to navigate to the DetailView with weather data
//	func goToDetail(with weatherData: WeatherData) {
//		self.currentView = AnyView(
//			DetailView(coordinator: self, weatherData: weatherData)
//				.environmentObject(weatherViewModel)
//		)
//	}
//	
//	// Function to navigate back to the HomeView
//	func goBack() {
//		self.currentView = AnyView(
//			HomeView(coordinator: self)
//				.environmentObject(weatherViewModel)
//		)
//	}
}
