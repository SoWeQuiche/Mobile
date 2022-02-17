//
//  Network+Extensions.swift
//  SoWeQuiches
//
//  Created by Zakarya TOLBA on 15/02/2022.
//

import Foundation
import RetroSwift

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
    func intercept(_ request: inout URLRequest) async throws {
        
    }
}
