//
//  ProfileAssembler.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 24/05/22.
//

import Foundation

protocol ProfileAssembler {
  func resolve() -> ProfileNavigator
}

extension ProfileAssembler where Self: Assembler {
  
  func resolve() -> ProfileNavigator {
    return ProfileNavigator(assembler: self)
  }
}
