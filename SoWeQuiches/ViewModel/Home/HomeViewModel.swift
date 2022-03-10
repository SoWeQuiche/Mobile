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


    init(attendancesService: AttendanceService = AttendanceService(), userService: UserService = UserService()) {
        self.attendanceService = attendancesService
        self.userService = userService
    }

    private let userService: UserService
    private var attendanceService: AttendanceService
    private var userTimeSlots: [TimeSlot] = []

    @Published var nextTimeSlots: [TimeSlot] = []
    @Published var actualTimeSlot: TimeSlot?

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

        print(nextTimeSlots)
    }
}



final class AttendanceService {

    init() {}

    @Network<[TimeSlot]>(authenticated: .timeslots, method: .GET)
    var userTimeslots
    
}

struct TimeSlot: Decodable, Hashable {
    var groupName: String
    var organizationId: String
    var groupId: String
    var attendanceId: String?
    var timeSlotId: String?
    var endDate: Date?
    var startDate: Date?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        groupName = try container.decode(String.self, forKey: .groupName)
        organizationId = try container.decode(String.self, forKey: .organizationId)
        groupId = try container.decode(String.self, forKey: .groupId)
        attendanceId = try container.decodeIfPresent(String.self, forKey: .attendanceId)
        timeSlotId = try container.decode(String.self, forKey: .timeSlotId)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        endDate = try dateFormatter.date(from: container.decode(String.self, forKey: .endDate))
        startDate = try dateFormatter.date(from: container.decode(String.self, forKey: .startDate))
    }

    enum CodingKeys: String, CodingKey {
        case groupName,
             organizationId,
             groupId,
             attendanceId,
             timeSlotId,
             endDate,
             startDate
    }

    var dateOfCourse: String {
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .medium
        guard let startDate = startDate else {
            return ""
        }
        return formatter1.string(from: startDate)
    }

    var courseTimelapse: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        guard let startDate = self.startDate, let endDate = self.endDate else {
            return ""
        }
        let startTime = dateFormatter.string(from: startDate)
        let endTime = dateFormatter.string(from: endDate)

        return "\(startTime) à \(endTime)"
    }
}
