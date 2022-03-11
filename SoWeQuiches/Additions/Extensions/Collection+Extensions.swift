//
//  Collection+Extensions.swift
//  SoWeQuiches
//
//  Created by Maxence on 10/03/2022.
//

import Foundation

public extension Collection {

    /**
    - parameter index: The index of the wanted element

    - returns: The element at the specified index if it is within bounds, otherwise nil.
    */
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
