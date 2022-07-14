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

  func navigateToKesslerTabItem() -> KesslerTabItem {
    return KesslerTabItem(navigator: assembler.resolve(), kesslerViewModel: assembler.resolve())
  }

  func navigateToKesslerQuizView(kesslerQuizs: [KesslerQuiz], isBackToRoot: Binding<Bool>?) -> KesslerQuizView {
    return KesslerQuizView(navigator: assembler.resolve(), kesslerQuiz: kesslerQuizs, isBackToRoot: isBackToRoot)
  }

  func navigateToKesslerFinalView(score: Int) -> KesslerFinalView {
    return KesslerFinalView(score: score, kesslerViewModel: assembler.resolve())
  }

  func navigateToKesslerHistory() -> KesslerHistoryView {
    return KesslerHistoryView(kesslerViewModel: assembler.resolve())
  }
}
