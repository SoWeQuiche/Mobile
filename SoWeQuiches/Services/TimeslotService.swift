//
//  TimeslotService.swift
//  SoWeQuiches
//
//  Created by Nicolas Barbosa on 11/03/2022.
//

import Foundation
import RetroSwift

struct TimeslotService {

    @Network<[Timeslot]>(authenticated: .timeslots, method: .GET)
    var userTimeslots
}
