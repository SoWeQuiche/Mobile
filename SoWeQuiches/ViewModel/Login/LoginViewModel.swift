//
//  LoginViewModel.swift
//  SoWeQuiche
//
//  Created by Zakarya TOLBA on 15/02/2022.
//

import SwiftUI
import Foundation
import AuthenticationServices
import RetroSwift

class LoginViewModel: ObservableObject {
    @ObservedObject var applicationState: ApplicationState = .shared
    @Keychained(key: .accessToken) var accessToken
    
    @Published var isLoading: Bool = false
    @Published var formError: FormError?
    @Published var mail: String = ""
    @Published var password: String = ""
    
    private var userService: UserService
    
    var hasEmptyField: Bool {
        return mail.isEmpty || password.isEmpty
    }
    
    init(userService: UserService = UserService()) {
        self.userService = userService
    }
    
    func login(mail: String, password: String) async {
        isLoading = true
        
        do {
            if hasEmptyField {
                withAnimation {
                    formError = .emptyFields
                    isLoading = false
                }
                return
            }
            
            let dto = LoginDTO(mail: mail, password: password)
            let result = try await userService.userLogin.call(body: dto)
            accessToken = result.token
            applicationState.state = .authenticated
            isLoading = false
        } catch (let error) {
            print(error)
            withAnimation {
                isLoading = false
                formError = .badCredentials
            }
        }
    }
    
    func generateRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
//        request.nonce = authProvider.generateNonce()
    }

    func authenticationComplete(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .failure(let error):
            print(error)
        case .success(let authorization):
//            Task { await authenticateWithFirebase(authorization) }
            guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
                  let identityTokenData = credential.identityToken,
                  let id_token = String(data: identityTokenData, encoding: .utf8) else {
                        print("ta mère")
                        return
                  }
      
            let lastname = credential.fullName?.familyName ?? ""
            let firstname = credential.fullName?.givenName ?? ""
            let dto = RegisterSWADTO(lastname: lastname, firstname: firstname, id_token: id_token)
            Task { try await userService.userLoginApple.call(body: dto) }
        }
    }
    
    enum FormError {
        case emptyFields
        case badCredentials
        
        var message: String {
            switch self {
            case .emptyFields: return "Un ou plusieurs champs sont vides"
            case .badCredentials: return "Mauvais mot de passe ou adresse mail"
            }
        }
    }
}
