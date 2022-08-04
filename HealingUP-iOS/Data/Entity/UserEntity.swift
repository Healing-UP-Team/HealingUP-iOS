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
    case fcmToken = "fcm_token"
    case experience = "experience"
  }

  var userId: String?
  var role: UserRoleEntity?
  var name: String?
  var email: String?
  var age: Int?
  var minimumHrv: Double?
  var fcmToken: String?
  var experience: String?

  init(userId: String?, role: UserRoleEntity?, name: String?, email: String?, age: Int?, minimumHrv: Double?, fcmToken: String?, experience: String?) {
    self.userId = userId
    self.role = role
    self.name = name
    self.email = email
    self.age = age
    self.minimumHrv = minimumHrv
    self.fcmToken = fcmToken
    self.experience = experience
  }

}
