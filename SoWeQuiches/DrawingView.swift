//
//  DrawingView.swift
//  SoWeQuiches
//
//  Created by Nicolas Barbosa on 15/02/2022.
//

import SwiftUI
import PencilKit

struct DrawingView: View {

    @ObservedObject var viewModel: DrawingViewModel

    var body: some View {
        VStack {
            CanvasView(canvasView: $viewModel.canvasView)
                .background(.red)
                .ignoresSafeArea()
            Button(action: {
                Task {
                    await viewModel.saveSignature()
                }
            }) {
                Text("Sauvegarder")
            }
            Image(uiImage: viewModel.image)
                .frame(width: 400, height: 400)
        }
    }
}

struct DrawingView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingView(viewModel: DrawingViewModel())
    }
}
