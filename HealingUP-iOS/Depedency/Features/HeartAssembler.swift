//
//  HeartAssembler.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 21/06/22.
//

import Foundation

protocol HeartAssembler {
  func resolve() -> HeartRateViewModel
  func resolve() -> HeartRateNavigator
}

extension HeartAssembler where Self: Assembler {
  
  func resolve() -> HeartRateViewModel {
    return HeartRateViewModel()
  }
  
  func resolve() -> HeartRateNavigator {
    return HeartRateNavigator(assembler: self)
  }
}
