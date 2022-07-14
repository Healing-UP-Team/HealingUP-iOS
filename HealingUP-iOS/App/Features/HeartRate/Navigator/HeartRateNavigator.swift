//
//  HeartRateNavigator.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 21/06/22.
//

import Foundation
import SwiftUI

struct HeartRateNavigator {
  private let assembler: Assembler

  init(assembler: Assembler) {
    self.assembler = assembler
  }

  func navigateToHeartRateTabItem(tabSelection: Binding<Int>) -> HeartRateTabItem {
    return HeartRateTabItem(navigator: assembler.resolve(), viewModel: assembler.resolve(), tabSelection: tabSelection)
  }

  func navigateToKesslerTabItem() -> KesslerTabItem {
    let navigator: KesslerNavigator = assembler.resolve()
    return navigator.navigateToKesslerTabItem()
  }
}
