//
//  ScheduleMapper.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 20/07/22.
//

import Foundation

extension ScheduleEntity {
  func map() -> Schedule {
    return Schedule(
      id: UUID(uuidString: id.orEmpty()) ?? UUID(),
      userId: userId.orEmpty(),
      counsellorId: counsellorId.orEmpty(),
      schedule: schedule?.toDate() ?? Date(),
      note: note.orEmpty(),
      status: ScheduleStatus(rawValue: status?.rawValue ?? "")!,
      linkMeeting: linkMeeting.orEmpty())
  }
}

extension Schedule {
  func map() -> ScheduleEntity {
    return ScheduleEntity(
      id: id.uuidString,
      userId: userId,
      counsellorId: counsellorId,
      schedule: String(schedule.timeIntervalSince1970),
      note: note,
      status: status,
      linkMeeting: linkMeeting)
  }
}
