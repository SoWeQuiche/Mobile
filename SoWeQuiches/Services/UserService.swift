//
//  File.swift
//  SoWeQuiches
//
//  Created by Zakarya TOLBA on 15/02/2022.
//

import Foundation
import RetroSwift

struct UserService {
    @Network<TokenResponse>(endpoint: .login, method: .POST)
    var userLogin
    
    @Network<TokenResponse>(endpoint: .refreshToken, method: .POST)
    var refreshToken
    
    @Network<TokenResponse>(endpoint: .loginApple, method: .POST)
    var userLoginApple
    
    @Network<User>(authenticated: .me, method: .GET)
    var getMe
}
