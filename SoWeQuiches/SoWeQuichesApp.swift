//
//  SoWeQuichesApp.swift
//  SoWeQuiches
//
//  Created by Nicolas Barbosa on 14/02/2022.
//

import SwiftUI

@main
struct SoWeQuichesApp: App {
    @ObservedObject var applicationState: ApplicationState = .shared
    
    var body: some Scene {
        WindowGroup {
            VStack {
                if applicationState.state == .authenticated {
                    HomeView(viewModel: HomeViewModel())
                } else if applicationState.state == .loading {
                    HStack {
                        ProgressView().padding(.horizontal, 10).progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        Text("Chargement...")
                            .bold()
                    }
                } else {
                    LoginView(viewModel: LoginViewModel())
                }
            }.task { await applicationState.openApp() }
        }
    }
}
