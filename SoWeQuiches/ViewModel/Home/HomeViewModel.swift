//
//  LoginViewModel.swift
//  SoWeQuiche
//
//  Created by Zakarya TOLBA on 15/02/2022.
//

import SwiftUI
import RetroSwift

class HomeViewModel: ObservableObject {
    @Keychained(key: .accessToken) var accessToken
    @ObservedObject var applicationState: ApplicationState = .shared


    init(attendancesService: TimeslotService = TimeslotService(), userService: UserService = UserService()) {
        self.attendanceService = attendancesService
        self.userService = userService
    }

    private let userService: UserService
    private var attendanceService: TimeslotService
    private var userTimeSlots: [Timeslot] = []

    @Published var nextTimeSlots: [Timeslot] = []
    @Published var actualTimeSlot: Timeslot?

    @MainActor
    func fetchUserTimeslots() async {
        do {
            userTimeSlots = try await attendanceService.userTimeslots.call()
            fetchActualTimeSlot()
            fetchNextTimeSlots()
        } catch(let error) {
            print(error)
        }
    }

    func disconnect() async {
        accessToken = nil
        await applicationState.disconnect()
    }

    private func fetchActualTimeSlot() {

        actualTimeSlot = userTimeSlots.first {
            if let startDate = $0.startDate {
                return startDate.timeIntervalSinceNow < 0
            }
            return false
            }
    }

    private func fetchNextTimeSlots() {
        nextTimeSlots = userTimeSlots.compactMap {
            guard let endDate = $0.endDate, let nextStartDate = actualTimeSlot?.startDate else { return nil }
            return endDate > nextStartDate ? $0 : nil
        }
    }
}
