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
    @ObservedObject var deepLinkManager: DeepLinkManager = .init()
    @ObservedObject var applicationState: AuthenticationManager = .init()

    init() {
#if DEBUG
        NFX.sharedInstance().start()
#endif
    }

    var body: some Scene {
        WindowGroup {
            VStack {
                if applicationState.state == .authenticated {
                    HomeView()
                } else if applicationState.state == .loading {
                    HStack {
                        ProgressView()
                            .padding(.horizontal, 10)
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        Text("Chargement...")
                            .bold()
                    }
                } else {
                    LoginView()
                }
            }
            .environmentObject(deepLinkManager)
            .environmentObject(applicationState)
            .task { await applicationState.openApp() }
            .onOpenURL { deepLinkManager.getDeepLink(from: $0) }
            .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { deepLinkManager.getDeepLink(from: $0.webpageURL) }
        }
    }
}
