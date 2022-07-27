//
//  HomeNavigator.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 23/05/22.
//

import Foundation
import SwiftUI

struct HomeNavigator {
  private let assembler: Assembler

  init(assembler: Assembler) {
    self.assembler = assembler
  }

  func navigateToHome() -> HomeView {
    return HomeView()
  }

  func navigateToHomeCounsellor() -> CounsellorHomeView {
    return CounsellorHomeView()
  }

  func navigateToSignIn() -> SignInView {
    let navigator: MembershipNavigator = assembler.resolve()
    return navigator.navigateToSignIn()
  }

  func navigateToSignUp(isSignIn: Binding<Bool>) -> SignUpView {
    let navigator: MembershipNavigator = assembler.resolve()
    return navigator.navigateToSignUp(isSignIn: isSignIn)
  }

  func navigateToOnboarding(data: [Onboarding], doneFuntion: @escaping () -> Void) -> OnboardingView {
    let navigator: OnboardingNavigator = assembler.resolve()
    return navigator.navigateToOnboarding(data: data, doneFunction: doneFuntion)
  }

  func navigateToTerms() -> TermsView {
    return TermsView()
  }
}
