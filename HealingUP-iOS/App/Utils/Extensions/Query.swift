//
//  Query.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 23/05/22.
//

import Foundation
import Firebase

extension Query {
  func whereRoleIsUser(isUser: Bool) -> Query {
    if isUser {
      return self
        .whereField("role", isEqualTo: UserRoleEntity.user.rawValue)
    } else {
      return self
    }
  }
}
