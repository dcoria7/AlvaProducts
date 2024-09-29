//
//  CreateVenueView.swift
//  AlvaProducts
//
//  Created by Daniel Coria on 04/04/24.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import _PhotosUI_SwiftUI

struct CreateVenueView: View {
    
    @FirestoreQuery(collectionPath: "users") var users: [User]
    @State private var userSelected: String = ""
    @State private var imageUserPickerPresented = false
    @State private var imageMenuPickerPresented = false
    @State private var avatarImage: Image?
    @State private var menuImage: Image?
    
    @StateObject var viewModel = CreateVenueViewModel()
    @StateObject var registrationViewModel = RegistrationViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack {
                        makeNewUserButton()
                        makeNewVenue()
                        
                        // Bordereed Picker Example
                        Picker("Pick Usuarios", selection: $userSelected){
                            ForEach(users, id: \.id) { user in
                                Text(user.email)
                            }
                        }
                        .pickerStyle(.wheel)
                        .background(RoundedRectangle(cornerRadius:15)
                            .stroke(.orange))
                        .padding()
                        
                        makeSaveButton()
                            .padding(.top, 30)
                    }
                }
            }
        }
//        .background(Color.gray)
    }
    
    @ViewBuilder
    func makeNewUserButton() -> some View {
        NavigationLink {
            AddEmailView()
                .navigationBarBackButtonHidden()
                .environmentObject(registrationViewModel)
        } label: {
            VStack {
                Text("Crear nuevo usuario")
                    .fontWeight(.semibold)
            }
        }
        .padding(.vertical, 30)
        .buttonStyle(.bordered)
    }
    
    @ViewBuilder
    func makeNewVenue() -> some View {
        VStack {
            TextField(
                "Nombre del venue",
                text: Binding(
                    get: { viewModel.venueName },
                    set: { viewModel.venueName = $0
                    })
            )
            .keyboardType(.asciiCapable)
            .disableAutocorrection(true)
            .foregroundColor(.black)
            .padding(.leading)
            .border(.black)
            .padding(.vertical)
            .onSubmit {
                viewModel.insertVenue(title: viewModel.venueName, userID: userSelected)
            }
            
            makeImagePicker()

        }
        .padding(.horizontal, 40)
    }
    
    @ViewBuilder
    func makeImagePicker() -> some View {
        
        VStack {
            PhotosPicker("Select venue logo", selection: $viewModel.selectedImage, matching: .images)
            
            viewModel.postImage?
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
        }
        
        VStack {
            PhotosPicker("Select menu image", selection: $viewModel.selectedMenuImage, matching: .images)
            
            viewModel.menuImage?
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
        }
        
    }
    
    @ViewBuilder
    private func makeSaveButton() -> some View {
        Button(action: {
            viewModel.insertVenue(title: viewModel.venueName, userID: userSelected)
        }) {
            Text("Guardar")
        }
        .buttonStyle(.bordered)
        .disabled(viewModel.isSaveDisable)
        
    }
}



#Preview {
    CreateVenueView()
}
