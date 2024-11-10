//
//  MainView.swift
//  MV-Project
//
//  Created by Daniel Coria on 15/08/23.
//

import SwiftUI

// DEPRECATED

struct MainView: View {
    let user: User?
    let venue: Venue?
	var coordinator: AppCoordinator
    @State private var selectedIndex = 0
    
    var body: some View {
        TabView {
            
			FeedView(user: user, coordinator: coordinator)
                .onAppear {
                    selectedIndex = 0
                }
                .tabItem {
                    Image(systemName: "house")
                }
                .tag(0)
            
			VenuesView(coordinator: coordinator)
                .onAppear {
                    selectedIndex = 1
                }
                .tabItem {
                    Image(systemName: "person")
                    Text("Venues")
                }
                .tag(1)
            
            if let user, let venue {
                CurrentUserProfileView(user: user, venue: venue)
                    .onAppear {
                        selectedIndex = 4
                    }
                    .tabItem {
                        Image(systemName: "person")
                    }
                    .tag(4)
            } else {
                // create user
            }
            
        }
//        .edgesIgnoringSafeArea(.top)
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//		MainView(user: User.mockUsers[0], venue: User.mockVenue[0], coordinator: AppCoordinator())
//    }
//}
