//
//  WebViewAssembler.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 27/07/22.
//

import Foundation

protocol WebViewAssembler {
  func resolve(url: String) -> WebViewModel
  func resolve() -> WebViewNavigator
}

extension WebViewAssembler where Self: Assembler {
  func resolve(url: String) -> WebViewModel {
    return WebViewModel(url: url)
  }

  func resolve() -> WebViewNavigator {
    return WebViewNavigator(assembler: self)
  }
}
