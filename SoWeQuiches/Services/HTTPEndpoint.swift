//
//  HTTPEndpoint.swift
//  SoWeQuiches
//
//  Created by Zakarya TOLBA on 15/02/2022.
//

import Foundation

enum HTTPEndpoint: String {
    var baseURL: String { "https://api.sign.quiches.ovh" }

    case login = "/auth/login"
    case loginApple = "/auth/login/apple-id"
    case refreshToken = "/auth/refresh"
    case me = "/auth/me"
    case fileUpload = "/files/upload"

    var url: String? {
        URL(string: baseURL)?.appendingPathComponent(self.rawValue).absoluteString
    }
}
