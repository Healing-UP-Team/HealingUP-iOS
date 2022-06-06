//
//  MembershipAssembler.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 23/05/22.
//

import Foundation

protocol MembershipAssembler {
  func resolve() -> MembershipNavigator
  func resolve() -> MembershipViewModel
  func resolve() -> FirebaseManager
}

extension MembershipAssembler where Self: Assembler {
  
  func resolve() -> MembershipNavigator {
    return MembershipNavigator(assembler: self)
  }
  
  func resolve() -> MembershipViewModel {
    return MembershipViewModel(firebaseManager: resolve())
  }
  
  func resolve() -> FirebaseManager {
    return DefaultFirebaseManager()
  }
}
