//
//  UserMapper.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 23/05/22.
//

import SwiftUI

extension UserEntity {
  func map() -> User {
    return User(userId: userId.orEmpty(), role: UserRole(rawValue: role?.rawValue ?? "")!, name: name.orEmpty(), email: email.orEmpty(), age: age ?? 0, minimumHrv: minimumHrv ?? 0, fcmToken: fcmToken.orEmpty())
  }
}

extension User {
  func map() -> UserEntity {
    return UserEntity(userId: userId, role: UserRoleEntity(rawValue: role.rawValue), name: name, email: email, age: age, minimumHrv: minimumHrv, fcmToken: fcmToken)
  }
}
