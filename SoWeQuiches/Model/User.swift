//
//  User.swift
//  SoWeQuiches
//
//  Created by Zakarya TOLBA on 17/02/2022.
//

import Foundation

public struct User: Decodable {
    public let mail: String
    public let firstName: String
    public let lastName: String

    public var displayName: String {
        "\(firstName) \(lastName)"
    }
}
