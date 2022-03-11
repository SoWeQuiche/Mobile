//
//  FileUploadResponse.swift
//  SoWeQuiches
//
//  Created by Nicolas Barbosa on 11/03/2022.
//

import Foundation

struct FileUploaderResponse: Decodable {
    let url: String
    let type: String
    let filename: String
    let _id: String
}
