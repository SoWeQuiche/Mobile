//
//  HTTPEndpoint.swift
//  SoWeQuiches
//
//  Created by Zakarya TOLBA on 15/02/2022.
//

import Foundation

enum HTTPEndpoint: String {
    var baseURL: String { "https://api.sign.quiches.ovh" }

    case authLogin = "/auth/login"
    case authRegister = "/auth/register"

    var url: URL? {
        URL(string: baseURL)?.appendingPathComponent(self.rawValue)
    }
}
