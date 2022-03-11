//
//  PKCanvasView.swift
//  SoWeQuiches
//
//  Created by Maxence on 11/03/2022.
//

import PencilKit

extension PKCanvasView {
    var image: UIImage {
        let drawing = self.drawing
        let visibleRect = self.bounds
        let image = drawing.image(from: visibleRect, scale: UIScreen.main.scale)

        return image
    }
}
