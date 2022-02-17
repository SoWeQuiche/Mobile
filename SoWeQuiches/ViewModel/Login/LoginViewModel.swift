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
    @Published var wrongCredentials: Bool = false
    private var userService: UserService
    
    init(userService: UserService = UserService()) {
        self.userService = userService
    }
    
    func login(mail: String, password: String) async {
        do {
            let dto = LoginDTO(mail: mail, password: password)
            let result = try await userService.userLogin.call(body: dto)
            accessToken = result.token
            applicationState.state = .authenticated
            isLoading = false
        } catch (let error) {
            print(error)
        }
    }
}
