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
  
  func navigateToKesslerQuizView(kesslerQuizs: [KesslerQuiz]) -> KesslerQuizView {
    return KesslerQuizView(kesslerQuiz: kesslerQuizs)
  }
  
  func navigateToKesslerFinalView(score: Int) -> KesslerFinalView {
    return KesslerFinalView(score: score)
  }
}
