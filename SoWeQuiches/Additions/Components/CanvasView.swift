//
//  CanvasView.swift
//  SoWeQuiches
//
//  Created by Nicolas Barbosa on 15/02/2022.
//

import PencilKit
import SwiftUI

struct CanvasView: UIViewRepresentable {
    let canvasView: PKCanvasView

    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.tool = PKInkingTool(.pen, color: .gray, width: 10)
        canvasView.drawingPolicy = .anyInput
        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {}
}
