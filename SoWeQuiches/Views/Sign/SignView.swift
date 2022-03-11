//
//  SignView.swift
//  SoWeQuiches
//
//  Created by Nicolas Barbosa on 15/02/2022.
//

import SwiftUI
import PencilKit

struct SignView: View {
    @Environment(\.dismiss) var dismiss
    let canvasView = PKCanvasView()

    let attendanceService = AttendanceService()
    let attendance: Attendance

    var body: some View {
        VStack(alignment: .center) {
            Text(attendance.name)
                .foregroundColor(Color.white)
                .font(.title)
                .bold()
                .padding(.top, 40)

            Text(attendance.timeslot)
                .foregroundColor(Color.white)
                .font(.title2)

            Spacer()

            CanvasView(canvasView: canvasView)
                .frame(maxWidth: .infinity, maxHeight: 400)

            Button(action: { clearCanvas() }) {
                Text("Effacer ma signature")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
            }
            .foregroundColor(.white)
            .cornerRadius(50)

            Spacer()

            Button(action: { await saveSignature() }) {
                Text("Valider ma présence")
                    .bold()
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

struct SignView_Previews: PreviewProvider {
    static var previews: some View {
        SignView(attendance: Attendance(name: "Anglais", timeslot: "9h - 18h"))
    }
}
