//
//  DrawingViewModel.swift
//  SoWeQuiches
//
//  Created by Nicolas Barbosa on 17/02/2022.
//

import Foundation
import PencilKit
import RetroSwift

class DrawingViewModel: ObservableObject {

    @Published var canvasView = PKCanvasView()
    @Published var image = UIImage()

    @Network<Void>(authenticated: .fileUpload, method: .POST)
    var fileUploader

    func saveSignature() async {
        image = await canvasView.saveAsUIImage()
        guard let dataImage = image.pngData() else { return }
        do {
            try await fileUploader.uploadFile(filename: "\(UUID().uuidString).png", filetype: "image/png", data: dataImage)
        } catch(let error) {
            print(error)
        }
    }
}

extension PKCanvasView {

    func saveAsUIImage() -> UIImage {
        let drawing = self.drawing
        let visibleRect = self.bounds
        let image = drawing.image(from: visibleRect, scale: UIScreen.main.scale)
        return image
    }
}



private class JWTNetworkRequestInterceptor: NetworkRequestInterceptor {
//    let userService = UserService()

    func intercept(_ request: inout URLRequest) async throws {
//        guard let token = try? await userService.getMe.call() else {
//                throw NetworkError.custom("NO_AVAILABLE_TOKEN")
//        }
        request.addValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MjBlMjUwNDllMGE0MDQ0NWMxNjRlNDAiLCJpYXQiOjE2NDUwOTQxNzYsImV4cCI6MTY2MDY0NjE3Nn0.Cu2n46SdP1aG4h2FyYyvPS825o56xRKCpYpNEPaQPQ8", forHTTPHeaderField: "authorization")
    }
}
