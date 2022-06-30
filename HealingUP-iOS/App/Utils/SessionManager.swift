//
//  SessionManager.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 29/06/22.
//

import SwiftUI

enum KeyValue: String {
  case age
  case hrvNormal
}

class SessionManager: ObservableObject {
  
  static let shared = SessionManager()
  
  static func setUserAge(age: Int) {
    UserDefaults.standard.set(age, forKey: KeyValue.age.rawValue)
  }
  
  static func getUserAge() -> Int {
    return UserDefaults.standard.integer(forKey: KeyValue.age.rawValue)
  }
  
  static func getHrvNormal() -> Double {
    return UserDefaults.standard.double(forKey: KeyValue.hrvNormal.rawValue)
  }
  
  static func setHrvNormal(hrv: Double) {
    UserDefaults.standard.set(hrv, forKey: KeyValue.hrvNormal.rawValue)
  }
}


