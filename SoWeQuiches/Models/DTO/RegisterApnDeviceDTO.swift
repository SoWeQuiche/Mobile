//
//  RegisterApnDeviceDTO.swift
//  SoWeQuiches
//
//  Created by Maxence on 11/03/2022.
//

import Foundation

struct RegisterApnDeviceDTO: Encodable {
    let deviceId: String
    let deviceType: String = "iOS"
}
