//
//  LoginViewModel.swift
//  SoWeQuiche
//
//  Created by Zakarya TOLBA on 15/02/2022.
//

import SwiftUI

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
    
    enum FormError {
        case emptyFields
        case badCredentials

        
        var maessage: String {
            switch self {
            case .emptyFields: return "Un ou plusieurs champs sont vides"
            case .badCredentials: return "Mauvais mot de passe ou adresse mail"
            }
        }
    }
}
