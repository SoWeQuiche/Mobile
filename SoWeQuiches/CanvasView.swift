//
//  CanvasView.swift
//  SoWeQuiches
//
//  Created by Nicolas Barbosa on 15/02/2022.
//

import PencilKit
import SwiftUI

struct CanvasView {
  @Binding var canvasView: PKCanvasView
}

extension CanvasView: UIViewRepresentable {
    
  func makeUIView(context: Context) -> PKCanvasView {
    canvasView.tool = PKInkingTool(.pen, color: .gray, width: 10)
      canvasView.drawingPolicy = .anyInput
    #if targetEnvironment(simulator)
      canvasView.drawingPolicy = .anyInput
    #endif
    return canvasView
  }

  func updateUIView(_ uiView: PKCanvasView, context: Context) {}
}

extension PKCanvasView {

    func saveAsUIImage() -> UIImage {
        let drawing = self.drawing
        let visibleRect = self.bounds
        let image = drawing.image(from: visibleRect, scale: UIScreen.main.scale)
        return image
    }
}
