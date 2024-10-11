//
//  ProfileHeaderView.swift
//
//

import Kingfisher
import SwiftUI

struct ProfileHeaderView: View {
    @State private var showEditProfile = false
	@ObservedObject var viewModel: PostGridViewModel

    var body: some View {
        VStack(spacing: 10) {
            
			// pic and status
            HStack {
                CircularProfileImageView(user: viewModel.user, venue: viewModel.venue, size: .large)
                Spacer()
//                UserStatView(value: viewModel.postsCount, title: "Posts")
				
				VStack(alignment: .leading, spacing: 4) {
					Text("Nombre de usuario:") // TODO: Make an enum
						.foregroundStyle(.gray)
						.font(.footnote)
						.fontWeight(.light)
					
					Text(viewModel.user.username)
						.foregroundStyle(.white)
						.font(.title3)
						.fontWeight(.bold)
					
					Text("Nombre de la tienda:")
						.foregroundStyle(.gray)
						.font(.footnote)
						.fontWeight(.light)
					
					Text(viewModel.venue.title)
						.foregroundStyle(.white)
						.font(.footnote)
					
					Text("Correo:")
						.foregroundStyle(.gray)
						.font(.footnote)
						.fontWeight(.light)
					
					Text(viewModel.user.email)
						.foregroundStyle(.white)
						.font(.footnote)
					
				}
				.frame(maxWidth: .infinity, alignment: .leading)
				.padding(.horizontal)
				
				Toggle("Esta abierto?", isOn: $viewModel.isActive) // TODO: Localize
					.foregroundColor(.red)
					.toggleStyle(SwitchToggleStyle(tint: .blue))
					.onChange(of: viewModel.isActive) { oldValue, newValue in
						Task {
							try await viewModel.updateVenueStatus(newValue: newValue)
						}
					}
					
            }
            .padding(.horizontal)
			.padding(.bottom, 4)
			.padding(.top, 10)

            // Action Button
			Button {
				showEditProfile.toggle()
			} label: {
                Text("Edit Profile")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(width: 360, height: 34)
					.background(.white)
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .strokeBorder(Color.white, lineWidth: 1)
                    )
            }

            Divider()
        }
        .fullScreenCover(isPresented: $showEditProfile) {
			EditProfileView(user: viewModel.user)
        }
    }
}
