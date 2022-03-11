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

struct FileUploaderResponse: Decodable {
    let url: String
    let type: String
    let filename: String
    let _id: String
}
