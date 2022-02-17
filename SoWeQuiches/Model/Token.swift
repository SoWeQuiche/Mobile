//
//  Token.swift
//  SoWeQuiches
//
//  Created by Zakarya TOLBA on 15/02/2022.
//

public struct Token: Decodable {
    let token: String
//    let refreshToken: String

    enum CodingKeys: String, CodingKey {
        case token = "token"
//        case refreshToken = "refresh_token"
    }
}
