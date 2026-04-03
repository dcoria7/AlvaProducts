//
//  Coordinator.swift
//  MilleanaApp
//
//  Created by DC on 04/11/24.
//

import SwiftUI

// Protocol defining the Coordinator pattern
protocol Coordinator {
	// Associated type for the ContentView, which must be a SwiftUI View
	associatedtype ContentView: View
	// Start function to initiate the coordinator's flow
	func start(contentViewModel: ContentViewModel, user: User?, venue: Venue?) -> ContentView
}

enum Screen: Identifiable, Hashable {
	case home
	case venueDetail(userID: String, venue: Venue)
//	case listHabit
//	case detailHabit(named: Habit)
	
	var id: Self { return self }
}


protocol AppCoordinatorProtocol: ObservableObject {
	var path: NavigationPath { get set }
	
	
	func push(_ screen:  Screen)
	func pop()
	func popToRoot()
}

class AppCoordinatorImpl: AppCoordinatorProtocol {
	@Published var path: NavigationPath = NavigationPath()
	
	
	// MARK: - Navigation Functions
	func push(_ screen: Screen) {
		path.append(screen)
	}
	
	func pop() {
		path.removeLast()
	}
	
	func popToRoot() {
		path.removeLast(path.count)
	}
	
	// MARK: - Presentation Style Providers
	@ViewBuilder
	func build(_ screen: Screen) -> some View {
		switch screen {
			case .home:
				EmptyView()
//				HomeView()
			case .venueDetail(let id, let venue):
				VenueDetailView(userId: id, venue: venue)
//			case .listHabit:
//				ListHabitView()
//			case .detailHabit(named: let habit):
//				DetailHabitView(habit: habit)
		}
	}
}
