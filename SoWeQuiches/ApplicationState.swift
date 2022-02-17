//
//  ApplicationState.swift
//  SoWeQuiches
//
//  Created by Zakarya TOLBA on 17/02/2022.
//

import Foundation

class ApplicationState: ObservableObject {
    static var shared: ApplicationState = .init()
    
    @Published var state: State = .unauthenticated
    
    enum State {
        case authenticated, unauthenticated
    }
}
