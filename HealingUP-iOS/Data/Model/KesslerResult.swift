//
//  Kessler.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 06/06/22.
//

import Foundation

struct KesslerResult: Equatable {
  var id: UUID = UUID()
  var userId: String = ""
  var stressLevel: StressLevel = .well
  var createAt: Date = Date()
}

enum StressLevel: String, Codable, Equatable {
  case well = "Likely to be well"
  case mild = "Likely to have a mild disorder"
  case moderate = "Likely to have a moderate disorder"
  case disorder = "Likely to have a severe disorder"
}
