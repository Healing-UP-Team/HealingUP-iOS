//
//  KesslerAssembler.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 06/06/22.
//

import Foundation

protocol KesslerAssembler {
  func resolve() -> KesslerNavigator
  func resolve() -> KesslerViewModel

  func resolve() -> KesslerTabItem
}

extension KesslerAssembler where Self: Assembler {

  func resolve() -> KesslerNavigator {
    return KesslerNavigator(assembler: self)
  }

  func resolve() -> KesslerTabItem {
    return KesslerTabItem(navigator: resolve(), kesslerViewModel: resolve())
  }

  func resolve() -> KesslerViewModel {
    return KesslerViewModel(firebaseManager: resolve())
  }
}
