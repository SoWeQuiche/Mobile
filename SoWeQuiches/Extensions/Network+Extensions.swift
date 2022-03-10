//
//  Network+Extensions.swift
//  SoWeQuiches
//
//  Created by Zakarya TOLBA on 15/02/2022.
//

import Foundation
import RetroSwift
import JWTDecode

extension Network {
    init(
        endpoint: HTTPEndpoint,
        method: HTTPMethod,
        headers: [String: String] = ["Content-Type": "application/json"]
    ) {
        self.init(url: endpoint.url ?? "", method: method, headers: headers, successStatusCodes: Set<Int>(200...209))
    }
    
    init(
        authenticated endpoint: HTTPEndpoint,
        method: HTTPMethod,
        headers: [String: String] = ["Content-Type": "application/json"]
    ) {
        self.init(url: endpoint.url ?? "", method: method, headers: headers, successStatusCodes: Set<Int>(200...209), requestInterceptor: JWTNetworkRequestInterceptor())
    }
    
}
    
private class JWTNetworkRequestInterceptor: NetworkRequestInterceptor {
    @Keychained(key: .accessToken) var accessToken
    @Keychained(key: .refreshToken) var refreshToken
    
    func intercept(_ request: inout URLRequest) async throws {
        guard var token = accessToken, let safeRefreshToken = refreshToken, let decodedToken = try? decode(jwt: token) else {
            throw NetworkError.custom("NO_AVAILABLE_TOKEN")
        }

        if decodedToken.expired {
            let dto = RefreshToken(refreshToken: safeRefreshToken)
            let userService = UserService()
            let result = try await userService.refreshToken.call(body: dto)
            token = result.token
            accessToken = result.token
            refreshToken = result.refreshToken
        }
        
        request.addValue("Bearer \(token)", forHTTPHeaderField: "authorization")
    }
}
