//
//  EditProfileView.swift
//  ClickLocal
//
//  Created by Daniel Coria on 04/04/24.
//

import PhotosUI
import SwiftUI
import Kingfisher
import JDStatusBarNotification

struct EditProfileView: View {
	@Environment(\.dismiss) var dismiss
	@StateObject var viewModel: EditProfileViewModel
	
	init(user: User, venue: Venue?) {
		self._viewModel = StateObject(wrappedValue: EditProfileViewModel(user: user, venue: venue))
	}
	
	var body: some View {
		VStack {
			// toolbar
			VStack {
				HStack {
					Button("Cancel") {
						dismiss()
					}
					
					Spacer()
					
					Text("Edit Profile")
						.font(.subheadline)
						.fontWeight(.semibold)
					
					Spacer()
					
					Button {
						Task {
							NotificationPresenter.shared.present("Cargando...")
							try await viewModel.updateUserData()
							
							NotificationPresenter.shared.dismiss()
							dismiss()
						}
					} label: {
						Text("Done")
							.font(.subheadline)
							.fontWeight(.bold)
					}
				}
				.padding(.horizontal)
				
				Divider()
			}
			
			ScrollView {
				
				// edit profile pic
				PhotosPicker(selection: $viewModel.selectedImage) {
					VStack {
						if let image = viewModel.profileImage {
							image
								.resizable()
								.scaledToFill()
								.frame(width: 80, height: 80)
								.foregroundStyle(Color.customBlack())
								.background(.green)
								.clipShape(Circle())
						} else {
							CircularProfileImageView(venue: viewModel.venue, size: .large)
						}
						Text("Editar logo")
							.font(.footnote)
							.fontWeight(.semibold)
						Divider()
					}
				}
				.padding(.vertical, 8)
				
				// edit profile info
				VStack {
					EditProfileRowView(title: "Nombre", placeholder: "Nombre de la tienda", text: $viewModel.venueTitle)
					EditProfileRowView(title: "Descripción", placeholder: "Description de la tienda", text: $viewModel.venueDescription)
					EditProfileRowView(title: "Teléfono", placeholder: "Teléfono de la tienda", text: $viewModel.venuePhone)
					EditProfileRowView(title: "Horario", placeholder: "Horario de la tienda", text: $viewModel.venueSchedule)
					EditProfileRowView(title: "Red Social @", placeholder: "Red Social de la tienda", text: $viewModel.venueNetwork)
					EditProfileRowView(title: "Tipo", placeholder: "Tipo de negocio", text: $viewModel.venueType)
				}
				Spacer()
				
				
				// edit menu pic
				PhotosPicker(selection: $viewModel.selectedMenuImage) {
					Text("Editar menu")
						.font(.footnote)
						.fontWeight(.semibold)
					
					if let image = viewModel.menuImage {
						image
							.resizable()
							.scaledToFit()
							.clipped() // Crop the image to the frame size
					} else {
						// menu image
						KFImage(URL(string: viewModel.venue?.menuImage ?? ""))
							.placeholder {
								ProgressView()
									.frame(width: 100)
							}
							.resizable()
							.scaledToFit()
							.clipped() // Crop the image to the frame size
					}
					
				}
			}
		}
	}
}

struct EditProfileRowView: View {
	let title: String
	let placeholder: String
	
	@Binding var text: String
	
	var body: some View {
		HStack {
			Text(title)
				.padding(.leading, 8)
				.frame(width: 100, alignment: .leading)
				.fontWeight(.bold)
			
			VStack {
				TextField(placeholder, text: $text)
				Divider()
			}
		}
		.font(.subheadline)
		.frame(height: 36)
	}
}

struct EditProfileView_Previews: PreviewProvider {
	static var previews: some View {
		EditProfileView(user: User.mockUsers[0], venue: Venue.init(title: "", available: false, date: Date.now, active: true, menuImage: nil, phone: "", schedule: "", typeOfVenue: ""))
	}
}
