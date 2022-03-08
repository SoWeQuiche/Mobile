//
//  Token.swift
//  SoWeQuiches
//
//  Created by Zakarya TOLBA on 15/02/2022.
//

struct Token: Decodable {
    let token: String
    let refreshToken: String
}

struct RefreshToken: Encodable {
    let refreshToken: String
}
