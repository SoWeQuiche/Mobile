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

    var url: String? {
        URL(string: baseURL)?.appendingPathComponent(self.rawValue).absoluteString
    }
}
