//
//  RefreshTokenKey.swift
//  SoWeQuiches
//
//  Created by Zakarya TOLBA on 08/03/2022.
//

import Foundation

struct RefreshTokenKey: KeychainKey {
    static var keyString: String = "RefreshToken"
    static let defaultValue: String? = nil
}

extension KeychainKey where Self == RefreshTokenKey {
    static var refreshToken: Self { .init() }
}
