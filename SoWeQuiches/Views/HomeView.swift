//
//  Login.swift
//  SoWeQuiche
//
//  Created by Zakarya TOLBA on 15/02/2022.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var deepLinkManager: DeepLinkManager
    @EnvironmentObject var applicationState: AuthenticationManager

    @State var selectedAttendance: Attendance?

    var body: some View {
        VStack {
            Text("Aucun séance prévu")
                .font(.title)
                .foregroundColor(Color.white)
            Spacer()

            VStack(spacing: 50) {
                VStack {
                    Text("Anglais")
                        .font(.title2)
                        .bold()
                        .foregroundColor(Color.white)
                    Text("9h - 18h")
                        .foregroundColor(Color.white)
                        .font(.title3)
                }

                HStack {
                    Button(action: { selectedAttendance = Attendance(name: "Anglais", timeslot: "9h - 18h") }) {
                        Text("Signer")
                            .foregroundColor(Color.white)
                            .frame(maxWidth: .infinity, maxHeight: 16)
                            .padding(.vertical)
                            .background(Color("orange"))
                            .cornerRadius(50)
                    }
                }
            }
            .padding(25)
            .background(Color("cardBackground"))
            .cornerRadius(5)

            Spacer()
            Text("Prochain cours")
                .font(.title)
                .foregroundColor(Color.white)

            Spacer()

            VStack(spacing: 50) {
                VStack {
                    Text("Anglais")
                        .font(.title2)
                        .bold()
                        .foregroundColor(Color.white)
                    Text("9h - 18h")
                        .foregroundColor(Color.white)
                        .font(.title3)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 50)
            .background(Color("cardBackground"))
            .cornerRadius(5)

            Spacer()

            Button(action: { await applicationState.disconnect() }) {
                Text("Disconnect")
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 25)
        .background(Color("background"))
        .sheet(item: $selectedAttendance) { SignView(attendance: $0) }
        .onChange(of: deepLinkManager.deepLink) { deepLink in
            if case let .sign(timeslotId: timeslotId, code: code) = deepLink {
                selectedAttendance = Attendance(name: "Tst\(code)", timeslot: timeslotId)
                deepLinkManager.clear()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
