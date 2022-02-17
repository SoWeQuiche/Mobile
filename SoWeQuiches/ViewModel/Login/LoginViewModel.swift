//
//  LoginViewModel.swift
//  SoWeQuiche
//
//  Created by Zakarya TOLBA on 15/02/2022.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @Published var isLoading: Bool = false
    @Published var wrongCredentials: Bool = false
    private var userService: UserService
    
    init(userService: UserService = UserService()) {
        self.userService = userService
    }
    
    func login(mail: String, password: String) async -> Any {
        do {
            let dto = LoginDTO(mail: mail, password: password)
            let test = try await userService.userLogin.call(body: dto)
            return test
        } catch (let error) {
            print(error)
            return error
        }
    }
}
