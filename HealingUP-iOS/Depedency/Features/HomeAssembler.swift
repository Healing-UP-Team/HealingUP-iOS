//
//  HomeAssembler.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 23/05/22.
//

import Foundation

protocol HomeAssembler {
  func resolve() -> HomeNavigator
}

extension HomeAssembler where Self: Assembler {
  
  func resolve() -> HomeNavigator {
    return HomeNavigator(assembler: self)
  }
}
