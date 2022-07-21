//
//  SessionManager.swift
//  HealingUp-Watch WatchKit Extension
//
//  Created by Dicky Buwono on 27/06/22.
//

import SwiftUI
import Combine

enum KeyValue: String {
  case loggedIn
  case age
  case hrvNormal
}

class SessionManager: ObservableObject {

  static let shared = SessionManager()
  @Published var islogin = false
  var subscriptions = Set<AnyCancellable>()

  init() {
    islogin = SessionManager.isLoggedIn()

    UserDefaults.standard
      .publisher(for: \.login)
      .handleEvents(receiveOutput: {
        self.islogin = $0
      })
      .sink { _ in }
      .store(in: &subscriptions)
  }

  static func isLoggedIn() -> Bool {
    return UserDefaults.standard.bool(forKey: KeyValue.loggedIn.rawValue)
  }

  static func setLoggedIn() {
    UserDefaults.standard.login = true
  }

  static func setNotLoggedIn() {
    UserDefaults.standard.login = false
  }

  static func getUserAge() -> Int {
    return UserDefaults.standard.integer(forKey: KeyValue.age.rawValue)
  }

  static func setUserAge(age: Int) {
    UserDefaults.standard.set(age, forKey: KeyValue.age.rawValue)
  }

  static func getHrvNormal() -> Double {
    return UserDefaults.standard.double(forKey: KeyValue.hrvNormal.rawValue)
  }

  static func setHrvNormal(hrv: Double) {
    UserDefaults.standard.set(hrv, forKey: KeyValue.hrvNormal.rawValue)
  }
}

extension UserDefaults {
  @objc var login: Bool {
    get {
      return bool(forKey: KeyValue.loggedIn.rawValue)
    }
    set {
      set(newValue, forKey: KeyValue.loggedIn.rawValue)
    }
  }
}
