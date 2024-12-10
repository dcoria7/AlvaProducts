//
//  UploadPostView.swift
//  ClickLocal
//
//  Created by Daniel Coria on 04/04/24.
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
                    Text("Cancelar") // TODO: Localize
                }

                Spacer()

                Text("Nuevo Post") // TODO: Localize
                    .fontWeight(.semibold)

                Spacer()

                Button {
					NotificationPresenter.shared.present("Cargando...")
					
                    Task {
						do {
							try await viewModel.uploadPost(caption: viewModel.caption)
							print("finished")
						} catch {
							print("something went wrong")
						}
						NotificationPresenter.shared.dismiss()
                        clearPostDataAndReturnToFeed()
                    }
                } label: {
                    Text("Enviar") // TODO: Localize
                        .fontWeight(.semibold)
                }
				.disabled(viewModel.isPostButtonDisabled)
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
		.onChange(isFalse: imagePickerPresented) {
			if viewModel.selectedImage == nil {
				clearPostDataAndReturnToFeed()
			}
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
