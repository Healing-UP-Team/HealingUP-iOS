//
//  ScheduleAssembler.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 20/07/22.
//

import Foundation

protocol ScheduleAssembler {
  func resolve() -> ScheduleViewModel
  func resolve() -> ScheduleNavigator
}

extension ScheduleAssembler where Self: Assembler {

  func resolve() -> ScheduleViewModel {
    return ScheduleViewModel(firebaseManager: resolve())
  }

  func resolve() -> ScheduleNavigator {
    return ScheduleNavigator(assembler: self)
  }
}
