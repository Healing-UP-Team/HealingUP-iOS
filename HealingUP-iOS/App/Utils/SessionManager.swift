//
//  SessionManager.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 29/06/22.
//

import SwiftUI
import FirebaseAuth
import Firebase

enum KeyValue: String {
  case age
  case hrvNormal
  case firstInstall
  case userType
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

  static func isFirstInstall() -> Bool {
    return !UserDefaults.standard.bool(forKey: KeyValue.firstInstall.rawValue)
  }

  static func setNotFirstInstall() {
    UserDefaults.standard.set(true, forKey: KeyValue.firstInstall.rawValue)
  }

  static func isLoggedIn() -> Bool {
    return DefaultFirebaseManager.shared.firebaseAuth.currentUser != nil
  }

  static func getUserId() -> String {
    guard let userId = Auth.auth().currentUser?.uid else { return "" }
    return userId
  }

  static func setUserCounsellor() {
    UserDefaults.standard.set(true, forKey: KeyValue.userType.rawValue)
  }

  static func setUserNotCounsellor() {
    UserDefaults.standard.set(false, forKey: KeyValue.userType.rawValue)
  }

  static func isCounsellor() -> Bool {
    return UserDefaults.standard.bool(forKey: KeyValue.userType.rawValue)
  }
}
