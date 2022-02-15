//
//  Token.swift
//  SoWeQuiches
//
//  Created by Zakarya TOLBA on 15/02/2022.
//

struct Token: Decodable {
    let accessToken: String
    let refreshToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
