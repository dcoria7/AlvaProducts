//
//  AddEmailView.swift
//  InstaSwift
//
//  Created by Bruno Rangel on 03/06/23.
//

import SwiftUI

struct AddEmailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: RegistrationViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Add your e-mail")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)
            Text("You'll use this e-mail to sign in to your account")
                .font(.footnote)
				.foregroundColor(.green)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            TextField("E-mail", text: $viewModel.email)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .modifier(ISTextViewModifier())
                .padding(.top)
            NavigationLink {
                CreateUsernameView()
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

struct AddEmailView_Previews: PreviewProvider {
    static var previews: some View {
        AddEmailView()
    }
}
