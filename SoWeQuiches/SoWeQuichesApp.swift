//
//  SoWeQuichesApp.swift
//  SoWeQuiches
//
//  Created by Nicolas Barbosa on 14/02/2022.
//

import SwiftUI

@main
struct SoWeQuichesApp: App {
    @Keychained(key: .accessToken) var accessToken
    @ObservedObject var applicationState: ApplicationState = .shared
    
    var body: some Scene {
        WindowGroup {
            Group {
                VStack {
                    if applicationState.state == .authenticated {
                        HomeView(viewModel: HomeViewModel())
                    } else {
                        LoginView(viewModel: LoginViewModel())
                    }
                }
            }
        }
    }
}
