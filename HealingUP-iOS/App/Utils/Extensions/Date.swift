//
//  Date.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 06/06/22.
//

import Foundation

extension Date {
  func toStringWith(format: String) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    dateFormatter.locale = Locale.init(identifier: "id")
    return dateFormatter.string(from: self)
  }
}
