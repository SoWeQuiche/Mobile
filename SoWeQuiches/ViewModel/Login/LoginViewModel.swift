//
//  LoginViewModel.swift
//  SoWeQuiche
//
//  Created by Zakarya TOLBA on 15/02/2022.
//

import SwiftUI
import Combine
import RetroSwift
//import QuichesCore

class LoginViewModel: ObservableObject {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @Published var isLoading: Bool = false
    @Published var wrongCredentials: Bool = false
    private var userService: UserService
    
    init(userService: UserService = UserService()) {
        self.userService = userService
    }
    
    func login(mail: String, password: String) async throws -> [Token] {
        let dto = LoginDTO(email: mail, password: password)
        return try await userService.userLogin.call(body: dto)
    }
}
