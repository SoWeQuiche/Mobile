//
//  ApplicationState.swift
//  SoWeQuiches
//
//  Created by Zakarya TOLBA on 17/02/2022.
//

import Foundation
import SwiftUI

class ApplicationState: ObservableObject {

    @Published var state: State = .loading
    static var shared: ApplicationState = .init()
    @Keychained(key: .accessToken) var accessToken
    
    func openApp() async {
        do {
            guard let _ = accessToken else { throw ApplicationStateError.notAuthenticated }
            await authenticate()
        } catch {
            await disconnect()
        }
    }

    func authenticate() async {
        await setState(.authenticated)
    }

    func disconnect() async {
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
