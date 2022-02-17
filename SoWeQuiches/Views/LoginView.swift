//
//  Login.swift
//  SoWeQuiche
//
//  Created by Zakarya TOLBA on 15/02/2022.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    
    @StateObject var viewModel: LoginViewModel
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 0) {
                VStack {
                    if let message = viewModel.formError?.maessage {
                        Text(message)
                            .foregroundColor(.red)
                            .padding()
                    }
                }.frame(height: 15)
                TextField("Adresse mail", text: $viewModel.mail)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                SecureField("Mot de passe", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button(action: {
                    Task {
                        await viewModel.login(mail: self.viewModel.mail, password: self.viewModel.password)
                    }
                }) {
                    HStack {
                        if viewModel.isLoading {
                            ProgressView().padding(.horizontal, 10).progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                            Text("Chargement...")
                                .bold()
                        } else {
                            Image(systemName: "key.fill")
                            Text("Connexion")
                                .bold()
                        }
                    }
                    
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.orange)
                .cornerRadius(.greatestFiniteMagnitude).shadow(color: Color.orange, radius: 5, x: 2, y: 2)
                .padding(.top, 20)
                .padding(.trailing, 20)
                
                SignInWithAppleButton(.signIn,
                    onRequest: { viewModel.generateRequest($0)},
                    onCompletion: { viewModel.authenticationComplete($0) })
            }
            .padding(.top, 20)
            .navigationBarTitle("Connexion")
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel())
    }
}
