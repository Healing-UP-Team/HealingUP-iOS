//
//  User.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 23/05/22.
//

import Foundation

enum UserRole: String {
  case user = "Pengguna"
  case psikolog = "Psikolog"
}

struct User: Equatable {
  static let empty: User = User()

  var userId: String = ""
  var role: UserRole = .user
  var name: String = ""
  var email: String = ""
  var age: Int = 0
  var minimumHrv: Double = 0
}
