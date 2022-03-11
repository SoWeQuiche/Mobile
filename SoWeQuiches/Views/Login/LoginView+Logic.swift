//
//  LoginView+Logic.swift
//  SoWeQuiches
//
//  Created by Maxence on 10/03/2022.
//

import SwiftUI
import Foundation
import AuthenticationServices

extension LoginView {
    func login() async {
        isLoading = true

        do {
            if hasEmptyField {
                withAnimation {
                    formError = .emptyFields
                    isLoading = false
                }
                return
            }

            let dto = LoginDTO(mail: mail, password: password)
            let response = try await userService.userLogin.call(body: dto)
            await applicationState.login(tokenResponse: response)
            let registerDto = RegisterApnDeviceDTO(deviceId: apnDevice ?? "")
            try await userService.registerDevice.call(body: registerDto)
            await applicationState.authenticate()
        } catch(_) {
            withAnimation {
                isLoading = false
                formError = .badCredentials
            }
        }
    }

    func generateSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
    }

    func loginWithSignInWithApple(_ result: Result<ASAuthorization, Error>) async {
        guard case let .success(authorization) = result,
              let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let identityTokenData = credential.identityToken,
              let codeData = credential.authorizationCode,
              let code = String(data: codeData, encoding: .utf8),
              let idToken = String(data: identityTokenData, encoding: .utf8) else {
                  formError = .signInWithAppleError

                  return
              }

        let dto = SWADTO(
            code: code,
            idToken: idToken,
            email: credential.email,
            firstname: credential.fullName?.givenName,
            lastname: credential.fullName?.familyName
        )

        do {
            let response = try await userService.userLoginApple.call(body: dto)
            await applicationState.login(tokenResponse: response)
            let registerDto = RegisterApnDeviceDTO(deviceId: apnDevice ?? "")
            try await userService.registerDevice.call(body: registerDto)
            await applicationState.authenticate()
            isLoading = false
        } catch(_) {
            withAnimation {
                isLoading = false
                formError = .signInWithAppleError
            }
        }
    }

    enum FormError {
        case emptyFields
        case badCredentials
        case signInWithAppleError

        var message: String {
            switch self {
            case .emptyFields: return "Un ou plusieurs champs sont vides"
            case .badCredentials: return "Mauvais mot de passe ou adresse mail"
            case .signInWithAppleError: return "Erreur de connexion avec Sign In with Apple"
            }
        }
    }
}
