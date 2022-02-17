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

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
#if DEBUG
        NFX.sharedInstance().start()
#endif
        return true
    }
}
