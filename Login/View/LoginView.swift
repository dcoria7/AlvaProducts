//
//  LoginView.swift
//  ClickLocal
//
//  Created by Daniel Coria on 04/04/24.
//

import SwiftUI
import JDStatusBarNotification

enum ActiveAlert {
	case credentials, forgotPassword
}

struct LoginView: View {
    @Environment(\.colorScheme) var colorScheme
    let user: User?
    @StateObject var viewModel = LoginViewModel()
    @StateObject var registrationViewModel = RegistrationViewModel()
	
	
	@State var showDialog: Bool = false
	@State private var activeAlert: ActiveAlert = .credentials
	
	// TODO: Localize
	let alertForgotPasswordTitle: String = "¿Olvidaste tu contraseña?"
	
	let credentialFailTitle: String = "Correo o contraseña invalidos"
	let credentialFailSubtitle: String = "Revisa tu correo/contraseña"

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Image(colorScheme == .light ? "instagram-black" : "instagram-white")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 220)
                VStack {
                    TextField("Ingresa tu email", text: $viewModel.email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .modifier(ISTextViewModifier())

                    SecureField("Ingresa tu contraseña", text: $viewModel.password)
                        .modifier(ISTextViewModifier())
                }

                Button {
					activeAlert = .forgotPassword
					showDialog = true
                } label: {
                    Text("Olvidé mi contraseña")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .padding(.top)
                        .padding(.trailing, 28)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)

                Button {
					
					if viewModel.email.isEmpty || viewModel.password.isEmpty || !viewModel.email.isValidEmail() {
						activeAlert = .credentials
						showDialog = true
					} else {
						Task {
							NotificationPresenter.shared.present("Cargando...")
							do {
								try await viewModel.signIn()
								NotificationPresenter.shared.dismiss()
							} catch {
								activeAlert = .credentials
								showDialog = true
							}
							NotificationPresenter.shared.dismiss()
						}
					}
                } label: {
                    Text("Login")
                        .font(.subheadline)
                        .fontWeight(.semibold)
						.foregroundStyle(Color.customWhite())
                        .frame(width: 360, height: 44)
						.background(Color.green())
                        .cornerRadius(8)
                }
                .padding(.vertical)

                Spacer()

//                Divider()

//                if let user, user.email == "dcoria7@gmail.com" {
//                    NavigationLink {
//                        AddEmailView()
//                            .navigationBarBackButtonHidden()
//                            .environmentObject(registrationViewModel)
//                    } label: {
//                        HStack(spacing: 3) {
//                            Text("Don't have an account?")
//                            Text("Sign Up")
//                                .fontWeight(.semibold)
//                        }
//                        .font(.footnote)
//                    }
//                    .padding(.vertical, 16)
//                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
		.alert(
			isPresented: $showDialog
		) {
			switch activeAlert {
				case .credentials:
					Alert(title: Text(credentialFailTitle), message: Text(credentialFailSubtitle), dismissButton: .default(Text("Aceptar")))
				case .forgotPassword:
					Alert(title: Text(alertForgotPasswordTitle), message: Text("Contacta al administrador para recuperar tu contraseña"), dismissButton: .default(Text("Aceptar")))
			}
			
		}
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(user: nil)
    }
}
