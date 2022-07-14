//
//  Query.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 23/05/22.
//

import Foundation
import Firebase

enum FirebaseRecordDate: String {
  case kesslerResult = "createAt"
}

extension Query {
  func whereRoleIsUser(isUser: Bool) -> Query {
    if isUser {
      return self
        .whereField("role", isEqualTo: UserRoleEntity.user.rawValue)
    } else {
      return self
    }
  }

  func orderByDate(recordDate: FirebaseRecordDate, descending: Bool = false) -> Query {
    return self.order(by: recordDate.rawValue, descending: descending)
  }
}
