//
//  MainTabView.swift
//  ClickLocal
//
//  Created by Daniel Coria on 04/04/24.
//

import SwiftUI

struct MainTabView: View {
    let user: User?
    let venue: Venue?
	var coordinator: AppCoordinator
	
    @EnvironmentObject var contentViewModel: ContentViewModel
    @State private var selectedIndex = 0

    var body: some View {
        TabView(selection: $selectedIndex) {
			Group {
				FeedView(user: user, coordinator: coordinator)
					.onAppear {
						selectedIndex = 0
					}
					.tabItem {
						Image(systemName: "house")
						Text("♣︎")
							.isHidden(selectedIndex == 0 ? false : true)
					}
					.tag(0)
				
				VenuesView(coordinator: coordinator)
					.onAppear {
						selectedIndex = 1
					}
					.tabItem {
						Image(systemName: "magnifyingglass")
						Text("♣︎")
							.isHidden(selectedIndex == 1 ? false : true)
					}
					.tag(1)
				
				if let user {
					if user.email == "dcoria7@gmail.com"{
						CreateVenueView()
							.onAppear {
								selectedIndex = 2
							}
							.tabItem {
								Image(systemName: "command")
								Text("Create Venue")
							}
							.tag(2)
					}
				}
				
				if user != nil {
					UploadPostView(tabIndex: $selectedIndex)
						.onAppear {
							selectedIndex = 3
						}
						.tabItem {
							Image(systemName: "plus.square")
							Text("♣︎")
								.isHidden(selectedIndex == 3 ? false : true)
						}
						.tag(3)
				}
				
				if let user, let venue {
					CurrentUserProfileView(user: user, venue: venue)
						.onAppear {
							selectedIndex = 4
						}
						.tabItem {
							Image(systemName: "person")
							Text("♣︎")
								.isHidden(selectedIndex == 4 ? false : true)
						}
						.tag(4)
				}
			}
			.toolbarBackground(Color.make(rgb: "2d3030", alpha: 1.0) ,for: .tabBar)
			.toolbarBackground(.visible, for: .tabBar)
			.toolbarColorScheme(.dark, for: .tabBar)
        }
		.tint(Color.customBlack())
    }
}
