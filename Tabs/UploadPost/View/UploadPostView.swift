//
//  UploadPostView.swift
//  InstaSwift
//
//  Created by Bruno Rangel on 04/06/23.
//

import PhotosUI
import SwiftUI
import JDStatusBarNotification

struct UploadPostView: View {
    @State private var imagePickerPresented = false
    
    @Binding var tabIndex: Int

    @StateObject var viewModel = UploadPostViewModel()

    var body: some View {
        VStack {
            // Action tool bar
            HStack {
                Button {
                    clearPostDataAndReturnToFeed()
                } label: {
                    Text("Cancel") // TODO: Localize
                }

                Spacer()

                Text("New Post") // TODO: Localize
                    .fontWeight(.semibold)

                Spacer()

                Button {
					NotificationPresenter.shared.present("Cargando...")
					
                    Task {
						if try await viewModel.uploadPost(caption: viewModel.caption) {
							print("finished")
						} else {
							print("something went wrong")
						}
						NotificationPresenter.shared.dismiss()
                        clearPostDataAndReturnToFeed()
                    }
                } label: {
                    Text("Enviar") // TODO: Localize
                        .fontWeight(.semibold)
                }
            }
            .padding(.horizontal)

            // Post image and caption
            HStack(spacing: 8) {
                if let image = viewModel.postImage {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipped()
                }
                TextField("Agrega la descripción ...", text: $viewModel.caption, axis: .vertical)
            }
            .padding()

            Spacer()
        }
		.setDefaultBackgroundColor()
        .onAppear {
            imagePickerPresented.toggle()
        }
        .photosPicker(isPresented: $imagePickerPresented, selection: $viewModel.selectedImage)
    }
    
    func clearPostDataAndReturnToFeed() {
        viewModel.caption = ""
        viewModel.selectedImage = nil
        viewModel.postImage = nil
        tabIndex = 0
    }
}

struct UploadPostView_Previews: PreviewProvider {
    static var previews: some View {
        UploadPostView(tabIndex: .constant(0))
    }
}
