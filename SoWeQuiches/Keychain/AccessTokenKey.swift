//
//  AccessTokenKey.swift
//  SoWeQuiches
//
//  Created by Zakarya TOLBA on 17/02/2022.
//

import Foundation

struct AccessTokenKey: KeychainKey {
    static var keyString: String = "AccessToken"
    static let defaultValue: String? = nil
}

extension KeychainKey where Self == AccessTokenKey {
    static var accessToken: Self { .init() }
}
