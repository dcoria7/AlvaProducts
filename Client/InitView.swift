//
//  InitView.swift
//  AlvaProducts
//
//  Created by Daniel Coria on 12/04/24.
//

import SwiftUI

struct InitView: View {
    
    @EnvironmentObject var contentViewModel: ContentViewModel
//    @StateObject var registrationViewModel = RegistrationViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Button {
                    contentViewModel.isAdmin = false
                } label: {
                    Text("Soy usuario")
                }
                
                Button {
                    contentViewModel.isAdmin = true
                } label: {
                    Text("Soy venue")
                }
            }
        }
    }
}

#Preview {
    InitView()
}
