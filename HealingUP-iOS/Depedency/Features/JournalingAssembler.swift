//
//  JournalingAssembler.swift
//  HealingUP-iOS
//
//  Created by Muhammad Rifki Widadi on 12/07/22.
//

import Foundation

protocol JournalingAssembler {
  func resolve() -> JournalingNavigator
  func resolve() -> JournalingViewModel
  func resolve() -> JournalingTabItem
}

extension JournalingAssembler where Self: Assembler {

  func resolve() -> JournalingNavigator {
    return JournalingNavigator(assembler: self)
  }

  func resolve() -> JournalingTabItem {
      return JournalingTabItem(navigator: resolve(), journalingViewModel: resolve())
  }

  func resolve() -> JournalingViewModel {
    return JournalingViewModel(firebaseManager: resolve())
  }
}
