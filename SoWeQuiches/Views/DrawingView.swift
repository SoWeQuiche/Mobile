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
        NavigationView {
            VStack {
                Spacer()

                VStack {
                    CanvasView(canvasView: $viewModel.canvasView)
                }
                    .frame(maxWidth: .infinity, maxHeight: 400)
                    .border(.red, width: 5)
                    .padding(.horizontal)
                Spacer()
                Button(action: {
                    Task {
                        await viewModel.saveSignature()
                    }
                }) {
                    Text("Sauvegarder")
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.orange)
                .cornerRadius(.greatestFiniteMagnitude).shadow(color: Color.orange, radius: 5, x: 2, y: 2)
                .padding(.top, 20)
                Spacer()

            }
            .navigationTitle("Pensez à signer !")
        }
    }
}

struct DrawingView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingView(viewModel: DrawingViewModel())
    }
}
