//
//  LoginViewModel.swift
//  SoWeQuiche
//
//  Created by Zakarya TOLBA on 15/02/2022.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    @Keychained(key: .accessToken) var accessToken
    @ObservedObject var applicationState: ApplicationState = .shared

    let userService: UserService = UserService()
    
    init() {}

    func disconnect() async {
        accessToken = nil
        await applicationState.disconnect()
    }
}
