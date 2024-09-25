//
//  InitContentView.swift
//  InstaSwift
//
//  Created by Bruno Rangel on 02/06/23.
//

import SwiftUI

struct InitContentView: View {
    @StateObject var viewModel = ContentViewModel()

    init() {
        UINavigationBar.appearance().tintColor = UIColor(Color.primary)
    }

    var body: some View {
        Group {
            if viewModel.userSession == nil {
                MainTabView(user: nil, venue: nil)
                    .environmentObject(viewModel)
            } else if let currentUser = viewModel.currentUser {
                let currentVenue = viewModel.currentVenue 
                MainTabView(user: currentUser, venue: currentVenue)
                    .environmentObject(viewModel)
            }
            
//            if viewModel.userSession == nil {
               
//                if let isAdmin = viewModel.isAdmin, isAdmin {
//                    MainTabView(user: nil)
//                        .environmentObject(viewModel)
//                } else if let isAdmin = viewModel.isAdmin, !isAdmin {
//                    MainView(user: nil)
//                } else {
//                    InitView()
//                        .environmentObject(viewModel)
//                }

//                LoginView()
//                    .environmentObject(registrationViewModel)
//            } else if let currentUser = viewModel.currentUser {
//                
//                MainTabView(user: currentUser)
//                    .environmentObject(viewModel)
//            }
            
        }
    }
}

struct InitContentView_Previews: PreviewProvider {
    static var previews: some View {
        InitContentView()
    }
}
