//
//  Kessler.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 06/06/22.
//

import Foundation
import SwiftUI

struct KesslerResult: Equatable {
  var id: UUID = UUID()
  var userId: String = ""
  var stressLevel: StressLevel = .well
  var createAt: Date = Date()
}

enum StressLevel: String, Codable, Equatable {
  case well = "Baik-baik saja"
  case mild = "Mengalami stres ringan"
  case moderate = "Mengalami stres sedang"
  case disorder = "Mengalami stres berat"

  var backgroundColor: Color {
    switch self {
    case .well:
      return Color(uiColor: .softBlue)
    case .mild:
      return Color(uiColor: .softYellow)
    case .moderate:
      return Color(uiColor: .softPinkSecond)
    case .disorder:
      return Color(uiColor: .softPinkFirst)
    }
  }
}
