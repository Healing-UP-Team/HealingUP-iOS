//
//  KesslerResultEntity.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 06/06/22.
//

import Foundation

struct KesslerResultEntity: Codable, BodyCodable {

  enum CodingKeys: String, CodingKey {
    case id = "kessler_id"
    case userId = "user_id"
    case stressLevel = "stress_level"
    case createAt = "createAt"
  }

  var id: String?
  var userId: String?
  var stressLevel: StressLevel?
  var createAt: String?

  init(id: String?, userId: String?, stressLevel: StressLevel?, createAt: String?) {
  self.id = id
  self.userId = userId
  self.stressLevel = stressLevel
  self.createAt = createAt
  }
}
