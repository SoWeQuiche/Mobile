//
//  User.swift
//  SoWeQuiches
//
//  Created by Zakarya TOLBA on 17/02/2022.
//

import Foundation

struct User: Decodable {
    let mail: String
    let firstName: String
    let lastName: String

    var displayName: String {
        "\(firstName) \(lastName)"
    }
}
