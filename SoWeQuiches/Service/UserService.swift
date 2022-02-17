//
//  File.swift
//  SoWeQuiches
//
//  Created by Zakarya TOLBA on 15/02/2022.
//

import Foundation
import RetroSwift

final class UserService {
    @Network<Token>(endpoint: .login, method: .POST)
    var userLogin
}
