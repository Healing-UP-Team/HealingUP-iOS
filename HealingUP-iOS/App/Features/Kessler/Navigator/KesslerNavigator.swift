//
//  KesslerNavigator.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 06/06/22.
//

import SwiftUI

struct KesslerNavigator {
  private let assembler: Assembler

  init(assembler: Assembler) {
    self.assembler = assembler
  }

  func navigateToKesslerQuizView(kesslerQuizs: [KesslerQuiz], isBackToRoot: Binding<Bool>?) -> KesslerQuizView {
    return KesslerQuizView(navigator: assembler.resolve(), kesslerQuiz: kesslerQuizs, isBackToRoot: isBackToRoot)
  }

  func navigateToKesslerFinalView(score: Int) -> KesslerFinalView {
    return KesslerFinalView(score: score, navigator: assembler.resolve(), kesslerViewModel: assembler.resolve())
  }

  func navigateToKesslerHistory() -> KesslerHistoryView {
    return KesslerHistoryView(kesslerViewModel: assembler.resolve())
  }

  func navigateToWebView(url: String, title: String? = nil) -> WebView {
    let navigator: WebViewNavigator = assembler.resolve()
    return navigator.navigateToWebView(url: url, title: title)
  }

  func navigateToDeepBreathing(title: String, icon: UIImage, message: String, buttonTitle: String) -> ResultView {
    return ResultView(title: title, icon: icon, message: message, buttonTitle: buttonTitle, buttonAction: {})
  }
}
