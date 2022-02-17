//
//  Login.swift
//  SoWeQuiche
//
//  Created by Zakarya TOLBA on 15/02/2022.
//

import SwiftUI

struct ErrorText: View {
    let text: String
    
    var body: some View {
        Text(text)
            .foregroundColor(.red)
            .padding()
    }
}

struct LoginView: View {
    
    @State private var mail: String = ""
    @State private var password: String = ""
    @State private var formSent : Bool = false
    
    var hasEmptyField: Bool {
        return mail.isEmpty || password.isEmpty
    }

    @ObservedObject private var viewModel: LoginViewModel

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 0){
                if formSent && hasEmptyField {
                    ErrorText(text: "Un ou plusieurs champs sont vides")
                } else if formSent && viewModel.wrongCredentials {
                    ErrorText(text: "Mauvais mot de passe ou adresse mail")
                }

                TextField("Adresse mail", text: $mail)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                SecureField("Mot de passe", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button(action: {
                    withAnimation {
                        viewModel.wrongCredentials = false

                        formSent = true
                        if !hasEmptyField {
                            viewModel.isLoading = true
                            Task {
                                await self.viewModel.login(mail: self.mail, password: self.password)
                            }
                        }

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
                }}.padding()
                .foregroundColor(.white)
                .background(Color.orange)
                .cornerRadius(.greatestFiniteMagnitude).shadow(color: Color.orange, radius: 5, x: 2, y: 2)
                .padding(.top, 20)
                .padding(.trailing, 20)
                }.padding(.top, 20)
                .navigationBarTitle("Connexion")
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel())
    }
}
