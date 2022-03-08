//
//  QrCodeScannerViewModel.swift
//  SoWeQuiches
//
//  Created by Zakarya TOLBA on 08/03/2022.
//

import Foundation
import UIKit

class QrCodeScannerViewModel: ObservableObject {
    @Published var isReload: Bool = false
    
    func setReload() {
        isReload = true
    }
}

