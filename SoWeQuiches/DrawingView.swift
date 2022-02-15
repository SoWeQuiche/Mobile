//
//  DrawingView.swift
//  SoWeQuiches
//
//  Created by Nicolas Barbosa on 15/02/2022.
//

import SwiftUI
import PencilKit

struct DrawingView: View {

    @State private var canvasView = PKCanvasView()
    @State private var image = UIImage()

    var body: some View {
        VStack {
            CanvasView(canvasView: $canvasView)
                .background(.red)
                .ignoresSafeArea()
            Button(action: { image = canvasView.saveAsUIImage() }) {
                Text("Sauvegarder")
            }
            Image(uiImage: image)
                .frame(width: 400, height: 400)
        }
    }
}

struct DrawingView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingView()
    }
}
