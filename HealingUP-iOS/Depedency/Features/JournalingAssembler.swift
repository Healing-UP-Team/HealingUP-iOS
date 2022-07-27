//
//  JournalingAssembler.swift
//  HealingUP-iOS
//
//  Created by Muhammad Rifki Widadi on 12/07/22.
//

import Foundation

protocol JournalingAssembler {
  func resolve() -> JournalingNavigator
  func resolve() -> JournalsViewModel
  func resolve() -> JournalingTabItem
}

extension JournalingAssembler where Self: Assembler {

  func resolve() -> JournalingNavigator {
    return JournalingNavigator(assembler: self)
  }

  func resolve() -> JournalingTabItem {
      return JournalingTabItem()
  }

  func resolve() -> JournalsViewModel {
    return JournalsViewModel()
  }
}
