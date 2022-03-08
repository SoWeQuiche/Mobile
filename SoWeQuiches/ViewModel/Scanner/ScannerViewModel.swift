//
//  ScannerViewModel.swift
//  SoWeQuiches
//
//  Created by Zakarya TOLBA on 08/03/2022.
//

import Foundation

class ScannerViewModel: ObservableObject {
    
    /// Defines how often we are going to try looking for a new QR-code in the camera feed.
    let scanInterval: Double = 1.0
    
    @Published var torchIsOn: Bool = false
    @Published var lastQrCode: String = "restaurantId"
    
    func onFoundQrCode(_ code: String) {
        self.lastQrCode = code
    }
}
