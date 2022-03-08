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
    @Binding var isPresenting: Bool

    var body: some View {
        VStack(alignment: .center) {
            Text(viewModel.attendance.name)
                .foregroundColor(Color.white)
                .font(.title)
                .bold()

            Text(viewModel.attendance.timeslot)
                .foregroundColor(Color.white)
                .font(.title2)

            Spacer()
            VStack {
                CanvasView(canvasView: $viewModel.canvasView)
            }
            .frame(maxWidth: .infinity, maxHeight: 400)

            Spacer()

            Button(action: {
                Task {
                    await viewModel.saveSignature()
                    isPresenting = false
                }
            }) {
                Text("Valider ma présence")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
            }
            .foregroundColor(.white)
            .background(Color("orange"))
            .cornerRadius(50)

            Spacer()
        }
        .padding()
        .background(Color("background"))
    }
}

struct DrawingView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingView(viewModel: DrawingViewModel(attendance: Attendance(name: "Anglais", timeslot: "9h - 18h")), isPresenting: .constant(true))
    }
}
