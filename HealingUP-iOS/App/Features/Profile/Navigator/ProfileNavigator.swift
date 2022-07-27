//
//  ProfileNavigator.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 24/05/22.
//

import Foundation
import SwiftUI

struct ProfileNavigator {
  private let assembler: Assembler

  init(assembler: Assembler) {
    self.assembler = assembler
  }

  func navigateToProfile() -> ProfileView {
    return ProfileView(viewModel: assembler.resolve(), navigator: self)
  }

  func navigateToSignIn() -> SignInView {
    let navigator: MembershipNavigator = assembler.resolve()
    return navigator.navigateToSignIn()
  }

  func navigateToTerms() -> TermsView {
    return TermsView()
  }
}
