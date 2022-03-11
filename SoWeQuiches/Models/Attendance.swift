//
//  Attendance.swift
//  SoWeQuiches
//
//  Created by Nicolas Barbosa on 08/03/2022.
//

import Foundation

struct Attendance: Identifiable {
    var id: String { name }

    var name: String
    var timeslot: String
}
