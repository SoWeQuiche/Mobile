//
//  TimeSlot.swift
//  SoWeQuiches
//
//  Created by Nicolas Barbosa on 11/03/2022.
//

import Foundation

struct Timeslot: Decodable, Hashable {
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
