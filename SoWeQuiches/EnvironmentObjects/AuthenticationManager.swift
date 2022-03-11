//
//  AuthenticationManager.swift
//  SoWeQuiches
//
//  Created by Zakarya TOLBA on 17/02/2022.
//

import Foundation
import SwiftUI

class AuthenticationManager: ObservableObject {
    @Keychained(key: .accessToken) var accessToken
    @Keychained(key: .refreshToken) var refreshToken

    @Published var state: State = .loading
    
    func openApp() async {
        do {
            guard let _ = accessToken else { throw ApplicationStateError.notAuthenticated }
            await authenticate()
        } catch {
            await disconnect()
        }
    }

    func login(tokenResponse: TokenResponse) async {
        self.accessToken = tokenResponse.token
        self.refreshToken = tokenResponse.refreshToken
    }

    func authenticate() async {
        await setState(.authenticated)
    }

    func disconnect() async {
        accessToken = nil
        refreshToken = nil
        await setState(.unauthenticated)
    }

    @MainActor
    private func setState(_ state: State) {
        withAnimation { [weak self] in
            self?.state = state
        }
    }

    enum State {
        case loading, unauthenticated, authenticated
    }
}

enum ApplicationStateError: Error {
    case notAuthenticated
}
