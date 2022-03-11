//
//  HomeView+Logic.swift
//  SoWeQuiches
//
//  Created by Nicolas Barbosa on 11/03/2022.
//

import Foundation
import SwiftUI

extension HomeView {

    func fetchUserTimeslots() async {
         do {
             userTimeSlots = try await timeslotService.userTimeslots.call()
             fetchActualTimeSlot()
             fetchNextTimeSlots()
         } catch(let error) {
             print(error)
         }
     }

     func disconnect() async {
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
