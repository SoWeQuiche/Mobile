//
//  SoWeQuichesApp.swift
//  SoWeQuiches
//
//  Created by Nicolas Barbosa on 14/02/2022.
//

import SwiftUI

@main
struct SoWeQuichesApp: App {
    
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @ObservedObject var loginViewModel = LoginViewModel()

    var body: some Scene {
        WindowGroup {
            Group {
                VStack {
                    if self.isLoggedIn {
                        // Home view
                    } else {
                        LoginView(viewModel: loginViewModel)
                    }
                }
            }
        }
    }
}
