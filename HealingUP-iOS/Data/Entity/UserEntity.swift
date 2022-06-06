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
  }
  
  
  var userId: String?
  var role: UserRoleEntity?
  var name: String?
  var email: String?
  
  init(userId: String?, role: UserRoleEntity?, name: String?, email: String?) {
    self.userId = userId
    self.role = role
    self.name = name
    self.email = email
  }
  
}
