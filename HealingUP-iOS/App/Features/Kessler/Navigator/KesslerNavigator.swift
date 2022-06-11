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
  
  func navigateToKesslerQuizView(kesslerQuizs: [KesslerQuiz], isFirstTime: Binding<Bool>?) -> KesslerQuizView {
    return KesslerQuizView(navigator: assembler.resolve(), kesslerQuiz: kesslerQuizs, isFirstTime: isFirstTime)
  }
  
  func navigateToKesslerFinalView(score: Int) -> KesslerFinalView {
    return KesslerFinalView(score: score, kesslerViewModel: assembler.resolve())
  }
  
  func navigateToKesslerDataListView(isFirsTime: Binding<Bool>? = nil) -> KesslerDataListView {
    return KesslerDataListView(kesslerViewModel: assembler.resolve(), isFirsTime: isFirsTime)
  }
}
