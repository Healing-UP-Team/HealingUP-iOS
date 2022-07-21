//
//  String.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 23/05/22.
//

import Foundation

extension Optional where Wrapped == String {
  func orEmpty() -> String {
    return self ?? ""
  }
}

extension String {
  func toDate(withFormat format: String = "yyyy-MM-dd'T'HH:mm:ss'Z'") -> Date {
    let timeInterval = Double(self) ?? 0.0
    let date = Date(timeIntervalSince1970: timeInterval)
    return date
  }
}
