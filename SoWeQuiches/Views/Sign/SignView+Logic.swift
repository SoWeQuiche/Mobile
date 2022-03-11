//
//  SignView+Logic.swift
//  SoWeQuiches
//
//  Created by Maxence on 10/03/2022.
//

import Foundation
import PencilKit

extension SignView {
    func clearCanvas() {
        canvasView.drawing = PKDrawing()
    }

    @MainActor
    func saveSignature() async {
        guard let dataImage = canvasView.image.pngData() else { return }

        do {
            let fileUploaderResponse = try await attendanceService.fileUploader.uploadFile(filename: "sign.png", filetype: "image/png", data: dataImage)
            guard let attendanceId = attendanceTimeSlot.attendanceId else { return }
            try await attendanceService.sign.call(body: SignRequestDTO(signFileId: fileUploaderResponse._id), pathKeysValues: ["attendanceId": attendanceId])
            dismiss()
        } catch(let error) {
            print(error)
        }
    }
}
