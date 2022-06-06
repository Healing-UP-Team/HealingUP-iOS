//
//  MembershipNavigator.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 23/05/22.
//

import Foundation
import SwiftUI

struct MembershipNavigator {
  private let assembler: Assembler
  
  init(assembler: Assembler) {
    self.assembler = assembler
  }
  
  func navigateToSignIn() -> SignInView {
    return SignInView(viewModel: assembler.resolve(), navigator: assembler.resolve())
  }
  
  func navigateToSignUp(isSignIn: Binding<Bool>) -> SignUpView {
    return SignUpView(viewModel: assembler.resolve(), navigator: assembler.resolve(), isSignIn: isSignIn)
  }
  
}
