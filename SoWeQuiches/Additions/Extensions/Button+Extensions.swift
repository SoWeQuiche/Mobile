//
//  Button+Extensions.swift
//  SoWeQuiches
//
//  Created by Maxence on 11/03/2022.
//

import SwiftUI

extension Button {
    init(action: @escaping () async -> Void, @ViewBuilder label: () -> Label) {
        self.init(action: { Task { await action() }}, label: label)
    }
}
