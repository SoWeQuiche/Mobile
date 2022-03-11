//
//  AttendanceService.swift
//  SoWeQuiches
//
//  Created by Maxence on 10/03/2022.
//

import Foundation
import RetroSwift

struct AttendanceService {
    @Network<FileUploaderResponse>(authenticated: .fileUpload, method: .POST)
    var fileUploader

    @Network<Void>(authenticated: .sign, method: .PATCH)
    var sign
}
