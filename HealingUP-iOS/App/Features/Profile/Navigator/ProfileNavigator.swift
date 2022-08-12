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

  func navigateToWebView(url: String, title: String? = nil) -> WebView {
    let navigator: WebViewNavigator = assembler.resolve()
    return navigator.navigateToWebView(url: url, title: title)
  }
  
  func navigateToPersonalInfo() -> PeronalInfoView {
    return PeronalInfoView(viewModel: assembler.resolve())
  }
}
