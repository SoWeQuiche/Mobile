//
//  SoWeQuichesApp.swift
//  SoWeQuiches
//
//  Created by Nicolas Barbosa on 14/02/2022.
//

import SwiftUI
import netfox

@main
struct SoWeQuichesApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
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

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
#if DEBUG
        NFX.sharedInstance().start()
#endif
        return true
    }
}
