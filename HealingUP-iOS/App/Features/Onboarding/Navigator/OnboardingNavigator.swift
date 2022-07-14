//
//  OnboardingNavigator.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 14/07/22.
//

import Foundation
import SwiftUI

struct OnboardingNavigator {
  private let assembler: Assembler
  
  init(assembler: Assembler) {
    self.assembler = assembler
  }
  
  func navigateToOnboarding(data: [Onboarding], doneFunction: @escaping () -> ()) -> OnboardingView {
    return OnboardingView(data: data, doneFunction: doneFunction)
  }
}
