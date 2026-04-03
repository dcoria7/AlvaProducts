//
//  CreateVenueView.swift
//  ClickLocal
//
//  Created by Daniel Coria on 04/04/24.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import _PhotosUI_SwiftUI
import JDStatusBarNotification

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
		.setDefaultBackgroundColor()
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
			.foregroundColor(Color.customBlack())
            .padding(.leading)
			.border(Color.customBlack())
            .padding(.vertical)
			
			TextField(
				"Descripcion de la tienda",
				text: Binding(
					get: { viewModel.venueDescription },
					set: { viewModel.venueDescription = $0
					})
			)
			.keyboardType(.asciiCapable)
			.disableAutocorrection(true)
			.foregroundColor(Color.customBlack())
			.padding(.leading)
			.border(Color.customBlack())
			.padding(.vertical)
			
			TextField(
				"Teléfono",
				text: Binding(
					get: { viewModel.venuePhone },
					set: { viewModel.venuePhone = $0
					})
			)
			.keyboardType(.asciiCapable)
			.disableAutocorrection(true)
			.foregroundColor(Color.customBlack())
			.padding(.leading)
			.border(Color.customBlack())
			.padding(.vertical)
			
			TextField(
				"Horario",
				text: Binding(
					get: { viewModel.venueSchedule },
					set: { viewModel.venueSchedule = $0
					})
			)
			.keyboardType(.asciiCapable)
			.disableAutocorrection(true)
			.foregroundColor(Color.customBlack())
			.padding(.leading)
			.border(Color.customBlack())
			.padding(.vertical)
			
			TextField(
				"Network",
				text: Binding(
					get: { viewModel.venueNetwork },
					set: { viewModel.venueNetwork = $0
					})
			)
			.keyboardType(.asciiCapable)
			.disableAutocorrection(true)
			.foregroundColor(Color.customBlack())
			.padding(.leading)
			.border(Color.customBlack())
			.padding(.vertical)
			
			TextField(
				"Tipo de negocio",
				text: Binding(
					get: { viewModel.venueType },
					set: { viewModel.venueType = $0
					})
			)
			.keyboardType(.asciiCapable)
			.disableAutocorrection(true)
			.foregroundColor(Color.customBlack())
			.padding(.leading)
			.border(Color.customBlack())
			.padding(.vertical)
            
            makeImagePicker()

        }
        .padding(.horizontal, 40)
//		.onSubmit {
//			viewModel.insertVenue(title: viewModel.venueName,
//								  description: viewModel.venueDescription,
//								  userID: userSelected,
//								  phone: viewModel.venuePhone,
//								  network: viewModel.venueNetwork,
//								  schedule: viewModel.venueSchedule,
//								  typeOfVenue: viewModel.venueType
//			)
//		}
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
			NotificationPresenter.shared.present("Cargando...")
			viewModel.insertVenue(title: viewModel.venueName,
								  description: viewModel.venueDescription,
								  userID: userSelected,
								  phone: viewModel.venuePhone,
								  network: viewModel.venueNetwork,
								  schedule: viewModel.venueSchedule,
								  typeOfVenue: viewModel.venueType
			)
			
			NotificationPresenter.shared.dismiss()
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
