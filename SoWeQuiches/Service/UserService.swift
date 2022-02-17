//
//  File.swift
//  SoWeQuiches
//
//  Created by Zakarya TOLBA on 15/02/2022.
//

import Foundation
import RetroSwift

final class UserService {
    
    init() {}
    
    @Network<Token>(endpoint: .login, method: .POST)
    var userLogin
    
    @Network<Token>(endpoint: .loginApple, method: .POST)
    var userLoginApple
    
    @Network<User>(authenticated: .me, method: .GET)
    var getMe
}
