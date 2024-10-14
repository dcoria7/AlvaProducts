//
//  ProfileHeaderView.swift
//
//

import Kingfisher
import SwiftUI

struct ProfileHeaderView: View {
    @State private var showEditProfile = false
	@ObservedObject var viewModel: PostClientGridViewModel

    var body: some View {
        VStack(spacing: 10) {
            
			// pic and status
            HStack {
				VStack {
					CircularProfileImageView(venue: viewModel.venue, size: .large)
					
					VStack {
						Text(viewModel.isActive ? "Abierto" : "Cerrado")
							.foregroundColor(viewModel.isActive ? .green : .indigo)
						Toggle("", isOn: $viewModel.isActive)
							.labelsHidden()
							.toggleStyle(SwitchToggleStyle(tint: viewModel.isActive ? .green : .indigo))
							.onChange(of: viewModel.isActive) { oldValue, newValue in
								Task {
									try await viewModel.updateVenueStatus(newValue: newValue)
								}
							}
					}
					.padding()
					.frame(width: 100)
					.overlay(
						RoundedRectangle(cornerRadius: 15)
							.stroke(lineWidth: 2)
							.foregroundColor(viewModel.isActive ? .green : .indigo)
					)
					
					//                UserStatView(value: viewModel.postsCount, title: "Posts")
				}
				
				VStack(alignment: .leading, spacing: 4) {
//					Text("Nombre de usuario:") // TODO: Make an enum
//						.foregroundStyle(.gray)
//						.font(.footnote)
//						.fontWeight(.light)
//					
//					Text(viewModel.user.username)
//						.foregroundStyle(.white)
//						.font(.title3)
//						.fontWeight(.bold)
					
					Text("Nombre de la tienda:")
						.foregroundStyle(.gray)
						.font(.footnote)
						.fontWeight(.light)
					
					Text(viewModel.venue?.title ?? "")
						.foregroundStyle(.white)
						.font(.footnote)
					
					Text("Correo:")
						.foregroundStyle(.gray)
						.font(.footnote)
						.fontWeight(.light)
					
					Text(viewModel.user?.email ?? "")
						.foregroundStyle(.white)
						.font(.footnote)
					
				}
				.frame(maxWidth: .infinity, alignment: .leading)
				.padding(.horizontal)
				
					
            }
            .padding(.horizontal)
			.padding(.bottom, 10)
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
			EditProfileView(user: viewModel.getCurrentUser())
        }
    }
}
