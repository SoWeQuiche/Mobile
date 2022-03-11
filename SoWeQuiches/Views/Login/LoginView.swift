//
//  Login.swift
//  SoWeQuiche
//
//  Created by Zakarya TOLBA on 15/02/2022.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject var applicationState: AuthenticationManager
    @Environment(\.colorScheme) private var colorScheme

    let userService: UserService = .init()

    @State var isLoading: Bool = false
    @State var formError: FormError?
    @State var mail: String = ""
    @State var password: String = ""

    var hasEmptyField: Bool {
        return mail.isEmpty || password.isEmpty
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 0) {
                Spacer()
                VStack {
                    if let message = formError?.message {
                        Text(message)
                            .fontWeight(.semibold)
                            .foregroundColor(.red)
                            .padding(.bottom, 30)
                    }
                }
                .frame(height: 15)

                TextField("e-mail", text: $mail)
                    .preferredColorScheme(.dark)
                    .padding(.vertical, 12)
                    .padding(.leading, 30)
                    .background(Color(UIColor(red: 52/255, green: 52/255, blue: 58/255, alpha: 100))).cornerRadius(5)
                    .foregroundColor(.white)
                    .font(.headline.weight(.semibold))
                    .padding(.horizontal, 30)
                    .padding(.bottom, 20)

                SecureField("mot de passe", text: $password)
                    .preferredColorScheme(.dark)
                    .padding(.vertical, 12)
                    .padding(.leading, 30)
                    .background(Color(UIColor(red: 52/255, green: 52/255, blue: 58/255, alpha: 100))).cornerRadius(5)
                    .foregroundColor(.white)
                    .font(.headline.weight(.semibold))
                    .padding(.horizontal, 30)

                Spacer()

                Button(action: { await login() }) {
                    HStack {
                        if isLoading {
                            ProgressView().padding(.horizontal, 10).progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                            Text("Chargement...")
                                .bold()
                        } else {
                            Image(systemName: "key.fill")
                            Text("Connexion")
                                .bold()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 55)
                    .foregroundColor(.white)
                    .background(Color("orange"))
                    .clipShape(Capsule())
                    .padding(.horizontal, 30)
                    .padding(.bottom, 25)
                }

                SignInWithAppleButton(
                    .signIn,
                    onRequest: { generateSignInWithAppleRequest($0)},
                    onCompletion: { result in
                        Task { await loginWithSignInWithApple(result) }
                    }
                )
                .signInWithAppleButtonStyle(.white)
                .frame(height: 55)
                .clipShape(Capsule())
                .padding(.horizontal, 30)
                .padding(.bottom, 25)
            }
            .padding(.top, 20)
            .navigationBarTitle("So We Quiches")
            .background(Color("background"))
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
