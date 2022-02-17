//
//  File.swift
//  SoWeQuiches
//
//  Created by Zakarya TOLBA on 15/02/2022.
//

import Foundation
import RetroSwift

public final class UserService {
    public init() {}
    
    @Network<Token>(endpoint: .login, method: .POST)
    public var userLogin
    
    @Network<User>(authenticated: .me, method: .GET)
    public var getMe
}
