//
//  OnboardingAssembler.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 14/07/22.
//

import Foundation

protocol OnboardingAssembler {
  func resolve() -> OnboardingNavigator
}

extension OnboardingAssembler where Self: Assembler {
  
  func resolve() -> OnboardingNavigator {
    return OnboardingNavigator(assembler: self)
  }
}
