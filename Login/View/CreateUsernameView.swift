//
//  CreateUsernameView.swift
//  InstaSwift
//
//  Created by Bruno Rangel on 03/06/23.
//

import SwiftUI

struct CreateUsernameView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: RegistrationViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Create username")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)
            Text("Pick a username for your new account. You can always change it later.")
                .font(.footnote)
				.foregroundColor(.green)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            TextField("Username", text: $viewModel.username)
                .autocapitalization(.none)
                .modifier(ISTextViewModifier())
                .padding(.top)
            NavigationLink {
                CreatePasswordView()
                    .navigationBarBackButtonHidden()
                    .environmentObject(viewModel)
            } label: {
                Text("Next")
                    .font(.subheadline)
                    .fontWeight(.semibold)
					.foregroundStyle(Color.customBlack())
                    .frame(width: 360, height: 44)
                    .background(Color(.systemBlue))
                    .cornerRadius(8)
            }
            .padding(.vertical)
            
            Spacer()
        }.toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Image(systemName: "chevron.left")
                    .imageScale(.large)
                    .onTapGesture {
                        dismiss()
                    }
            }
        }
    }
}

struct CreateUsernameView_Previews: PreviewProvider {
    static var previews: some View {
        CreateUsernameView()
    }
}
