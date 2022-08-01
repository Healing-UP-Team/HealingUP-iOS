//
//  Notifications.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 01/08/22.
//

import Foundation

struct Notifications {
  static let moveToCounselling = NSNotification.Name(rawValue: "moveToCounselling")
  static let moveToJournaling = NSNotification.Name(rawValue: "moveToJournaling")
  static let moveToBreath = NSNotification.Name(rawValue: "moveToBreath")
}

public extension NSNotification.Name {
  func post(with object: Any? = nil) {
    NotificationCenter.default.post(name: self, object: object)
  }
}
