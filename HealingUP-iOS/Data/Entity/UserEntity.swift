//
//  UserEntity.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 23/05/22.
//

import Foundation

enum UserRoleEntity: String, Codable {
  case user = "Pengguna"
  case psikolog = "Psikolog"
}

struct UserEntity: Codable, BodyCodable {

  enum CodingKeys: String, CodingKey {
    case userId = "user_id"
    case role = "role"
    case name = "name"
    case email = "email"
    case age = "age"
    case minimumHrv = "minimum_hrv"
  }

  var userId: String?
  var role: UserRoleEntity?
  var name: String?
  var email: String?
  var age: Int?
  var minimumHrv: Double?

  init(userId: String?, role: UserRoleEntity?, name: String?, email: String?, age: Int?, minimumHrv: Double?) {
    self.userId = userId
    self.role = role
    self.name = name
    self.email = email
    self.age = age
    self.minimumHrv = minimumHrv
  }

}
