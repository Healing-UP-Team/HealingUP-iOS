//
//  KesslerResultMapper.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 06/06/22.
//

import Foundation

extension KesslerResultEntity {
  func map() -> KesslerResult {
    return KesslerResult(id: UUID(uuidString: id.orEmpty()) ?? UUID(), userId: userId.orEmpty(), stressLevel: StressLevel(rawValue: stressLevel?.rawValue ?? "")!, createAt: createAt?.toDate() ?? Date())
  }
}

extension KesslerResult {
  func map() -> KesslerResultEntity {
    return KesslerResultEntity(id: id.uuidString, userId: userId, stressLevel: stressLevel, createAt: String(createAt.timeIntervalSince1970))
  }
}
