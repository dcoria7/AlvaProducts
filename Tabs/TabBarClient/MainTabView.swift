//
//  MainTabView.swift
//  InstaSwift
//
//  Created by Bruno Rangel on 02/06/23.
//

import SwiftUI

struct MainTabView: View {
    let user: User?
    let venue: Venue?
    @EnvironmentObject var contentViewModel: ContentViewModel
    @State private var selectedIndex = 0

    var body: some View {
        TabView(selection: $selectedIndex) {
            FeedView(user: user)
                .onAppear {
                    selectedIndex = 0
                }
                .tabItem {
                    Image(systemName: "house")
                }
                .tag(0)
            
//            SearchView()
//                .onAppear {
//                    selectedIndex = 1
//                }
//                .tabItem {
//                    Image(systemName: "magnifyingglass")
//                }
//                .tag(1)
            
            VenuesView()
                .onAppear {
                    selectedIndex = 1
                }
                .tabItem {
                    Image(systemName: "magnifyingglass")
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
                    }
                    .tag(3)
            }
            
//            Text("Notifications")
//                .onAppear {
//                    selectedIndex = 4
//                }
//                .tabItem {
//                    Image(systemName: "heart")
//                }
//                .tag(4)
            
            if let user, let venue {
                CurrentUserProfileView(user: user, venue: venue)
                    .onAppear {
                        selectedIndex = 4
                    }
                    .tabItem {
                        Image(systemName: "person")
                    }
                    .tag(4)
            }
        }
        .tint(.primary)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView(user: User.mockUsers[0], venue: User.mockVenue[0])
    }
}
