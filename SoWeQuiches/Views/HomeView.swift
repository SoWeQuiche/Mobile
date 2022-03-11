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
    @State private var isPresenting: Bool = false
    @State var selectedAttendance: Attendance?
    @State var nextTimeSlots: [Timeslot] = []
    @State var actualTimeSlot: Timeslot?
    @State var scannerViewIsPresented = false
    @State var showDisconnectAlert: Bool = false

    let userService: UserService = UserService()
    var timeslotService: TimeslotService = TimeslotService()
    @State var userTimeSlots: [Timeslot] = []

    var body: some View {
        ScrollView {
            VStack {
                Text(actualTimeSlot != nil ? actualTimeSlot?.groupName ?? "" : "Aucun séance prévu")
                    .font(.title)
                    .foregroundColor(Color.white)
                    .padding(.vertical, 30)

                VStack {
                    Text(actualTimeSlot?.groupName ?? "")
                        .font(.title2)
                        .bold()
                        .foregroundColor(Color.white)
                    Text(actualTimeSlot?.dateOfCourse ?? "")
                        .foregroundColor(Color.white)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                    Text(actualTimeSlot?.courseTimelapse ?? "")
                        .foregroundColor(Color.white)
                        .font(.title3)
                        .multilineTextAlignment(.center)

                    HStack {
                        Button(action: { scannerViewIsPresented = true }) {
                            Image(systemName: "qrcode.viewfinder")
                        }

                        Button(action: { selectedAttendance = Attendance(name: actualTimeSlot?.groupName ?? "", timeslot: actualTimeSlot?.courseTimelapse ?? "") }) {
                            Text("Signer")
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity, maxHeight: 16)
                                .padding(.vertical)
                                .background(Color("orange"))
                                .cornerRadius(50)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 50)
                .padding(.horizontal)
                .background(Color("cardBackground"))
                .cornerRadius(5)

                Text("\(nextTimeSlots.count) Prochain cours")
                    .font(.title)
                    .foregroundColor(Color.white)
                    .padding(.vertical, 30)

                ForEach(nextTimeSlots, id: \.self) { timeSlot in
                    VStack {
                        Text(timeSlot.groupName)
                            .font(.title2)
                            .bold()
                            .foregroundColor(Color.white)
                        Text(timeSlot.dateOfCourse)
                            .foregroundColor(Color.white)
                            .font(.title3)
                            .multilineTextAlignment(.center)
                        Text(timeSlot.courseTimelapse)
                            .foregroundColor(Color.white)
                            .font(.title3)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 75)
                    .padding(.vertical, 50)
                    .background(Color("cardBackground"))
                    .cornerRadius(5)
                    .padding(.horizontal)
                    .sheet(item: $selectedAttendance) { SignView(attendance: $0) }
                    .onChange(of: deepLinkManager.deepLink) { deepLink in
                        if case let .sign(timeslotId: timeslotId, code: code) = deepLink {
                            selectedAttendance = Attendance(name: "Tst\(code)", timeslot: timeslotId)
                            deepLinkManager.clear()
                        }
                    }
                }

                Button(action: { await disconnect() }) {
                    Text("Disconnect")
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 25)
        .background(Color("background"))
        .navigationBarHidden(true)
        .task {
            await fetchUserTimeslots()
        }
        .sheet(item: $selectedAttendance) { SignView(attendance: $0) }
        .sheet(isPresented: $scannerViewIsPresented) { ScannerView(foundQrCode: foundQRCode(_:)) }
        .onChange(of: deepLinkManager.deepLink) { deepLink in
            if case let .sign(timeslotId: timeslotId, code: code) = deepLink {
                selectedAttendance = Attendance(name: "Tst\(code)", timeslot: timeslotId)
                deepLinkManager.clear()
            }
            .alert(isPresented: $showDisconnectAlert) {
                Alert(title: Text("Déconnexion"),
                 message: Text("Êtes-vous sûr(e) de vouloir vous déconnecter?"),
                 primaryButton: .cancel(Text("Annuler")),
                 secondaryButton: .destructive(Text("Se déconnecter"), action: {
                    Task {
                        await disconnect()
                    }
                 }))
            }
        }
    }

    func foundQRCode(_ deepLink: DeepLinkManager.DeepLink) {
        scannerViewIsPresented = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            deepLinkManager.setDeepLink(deepLink)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView()
            HomeView()
                .previewDevice("iPhone SE (2nd generation)")
        }
    }
}
