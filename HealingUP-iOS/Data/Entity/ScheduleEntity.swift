//
//  ScheduleEntity.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 20/07/22.
//

import Foundation

struct ScheduleEntity: Codable, BodyCodable {

  enum CodingKeys: String, CodingKey {
    case id = "schedule_id"
    case userId = "user_id"
    case counsellorId = "counsellor_id"
    case schedule = "schedule"
    case note = "note"
    case status = "status"
    case linkMeeting = "link_meeting"
  }

  var id: String?
  var userId: String?
  var counsellorId: String?
  var schedule: String?
  var note: String?
  var status: ScheduleStatus?
  var linkMeeting: String?

  init(id: String?, userId: String?, counsellorId: String, schedule: String?, note: String, status: ScheduleStatus?, linkMeeting: String?) {
    self.id = id
    self.userId = userId
    self.counsellorId = counsellorId
    self.schedule = schedule
    self.note = note
    self.status = status
    self.linkMeeting = linkMeeting
  }
}
