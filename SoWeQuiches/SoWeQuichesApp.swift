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

class AppDelegate: NSObject, UIApplicationDelegate {
    @Keychained(key: .apnDevice) var apnDevice

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("D'oh: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }

        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceId = deviceToken.map { data in String(format: "%02.2hhx", data) }.joined()
        apnDevice = deviceId
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
}
