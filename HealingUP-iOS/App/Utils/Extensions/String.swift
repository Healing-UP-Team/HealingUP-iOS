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
    let dateFormatter = DateFormatter()
    dateFormatter.calendar = Calendar(identifier: .gregorian)
    dateFormatter.dateFormat = format
    dateFormatter.locale = Locale.init(identifier: "id_ID")
    let date = dateFormatter.date(from: self) ?? Date()
    return date
  }
}
