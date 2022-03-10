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
    @StateObject var viewModel: HomeViewModel
    @State private var isPresenting: Bool = false
 
    @State var selectedAttendance: Attendance?

  var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text(viewModel.actualTimeSlot != nil ? viewModel.actualTimeSlot?.groupName ?? "" : "Aucun séance prévu")
                        .font(.title)
                        .foregroundColor(Color.white)
                        .padding(.vertical, 50)
                    Spacer()

                    VStack(spacing: 50) {
                        VStack {
                            Text(viewModel.actualTimeSlot?.groupName ?? "")
                                .font(.title2)
                                .bold()
                                .foregroundColor(Color.white)
                            Text(viewModel.actualTimeSlot?.dateOfCourse ?? "")
                                .foregroundColor(Color.white)
                                .font(.title3)
                                .multilineTextAlignment(.center)
                            Text(viewModel.actualTimeSlot?.courseTimelapse ?? "")
                                .foregroundColor(Color.white)
                                .font(.title3)
                                .multilineTextAlignment(.center)
                        }
                    
Spacer()
                    Text("\(viewModel.nextTimeSlots.count) Prochain cours")
                        .font(.title)
                        .foregroundColor(Color.white)
                        .padding(.vertical, 50)

                    Spacer()

                    VStack(spacing: 50) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(viewModel.nextTimeSlots, id: \.self) { timeSlot in
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
                            }
                        }

                        Button("Disconnect") {
                            Task {
                                await viewModel.disconnect()
                            }
                        }
                    }
                }
                }
            .frame(maxWidth: .infinity)
            .navigationBarHidden(true)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView(viewModel: HomeViewModel())
            HomeView(viewModel: HomeViewModel())
                .previewDevice("iPhone SE (2nd generation)")
        }
    }
}
