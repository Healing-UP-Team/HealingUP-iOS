//
//  Schedule.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 20/07/22.
//

import Foundation

enum ScheduleStatus: String, Equatable, Codable {
  case waiting = "Menunggu"
  case scheduled = "Terjadwal"
  case rejected = "Ditolak"
  case done = "Selesai"
}

struct Schedule: Equatable {

  var id: UUID = UUID()
  var userId: String = ""
  var counsellorId: String = ""
  var schedule: Date = Date()
  var note: String = ""
  var status: ScheduleStatus = .waiting
  var linkMeeting: String = ""
}
