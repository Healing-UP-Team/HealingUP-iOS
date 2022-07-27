//
//  WebViewNavigator.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 27/07/22.
//

import Foundation
import SwiftUI

struct WebViewNavigator {
  private let assembler: Assembler

  init(assembler: Assembler) {
    self.assembler = assembler
  }

  func navigateToWebView(url: String, title: String? = nil) -> WebView {
    return WebView(title: title, webViewModel: assembler.resolve(url: url))
  }
}
