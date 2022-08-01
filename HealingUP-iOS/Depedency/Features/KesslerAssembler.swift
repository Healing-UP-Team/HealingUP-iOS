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
}

extension KesslerAssembler where Self: Assembler {

  func resolve() -> KesslerNavigator {
    return KesslerNavigator(assembler: self)
  }

  func resolve() -> KesslerViewModel {
    return KesslerViewModel(firebaseManager: resolve())
  }
}
