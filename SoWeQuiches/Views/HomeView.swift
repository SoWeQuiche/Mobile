//
//  Login.swift
//  SoWeQuiche
//
//  Created by Zakarya TOLBA on 15/02/2022.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    @State private var isPresenting: Bool = false
    var body: some View {
        NavigationView {
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
                            NavigationLink(destination: DrawingView(viewModel: DrawingViewModel(attendance: Attendance(name: "Anglais", timeslot: "9h - 18h")), isPresenting: $isPresenting), isActive: $isPresenting) {
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
                Button("Disconnect") {
                    Task {
                        await viewModel.disconnect()
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 25)
            .background(Color("background"))
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
    }
}
