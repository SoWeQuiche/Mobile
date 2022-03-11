//
//  ApnDeviceKey.swift
//  SoWeQuiches
//
//  Created by Maxence on 11/03/2022.
//

import Foundation

import Foundation

struct ApnDeviceKey: KeychainKey {
    static var keyString: String = "ApnDeviceId"
    static let defaultValue: String? = nil
}

extension KeychainKey where Self == ApnDeviceKey {
    static var apnDevice: Self { .init() }
}
