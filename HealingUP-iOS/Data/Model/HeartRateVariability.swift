//
//  HeartRateVariability.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 21/06/22.
//

import Foundation

public enum HRVDate {
  case today
  case week
  case month
}

struct HeartRateVariability {
  var heartRate: Double?
  var startDate: Date?
  var endDate: Date?
}
