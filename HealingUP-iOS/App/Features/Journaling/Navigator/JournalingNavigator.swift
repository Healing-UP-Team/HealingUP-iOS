//
//  JournalingNavigator.swift
//  HealingUP-iOS
//
//  Created by Muhammad Rifki Widadi on 12/07/22.
//

import SwiftUI

struct JournalingNavigator {
    private let assembler: Assembler

    init(assembler: Assembler) {
      self.assembler = assembler
    }

    func navigateToJournalingTabItem() -> JournalingTabItem {
        return JournalingTabItem()
    }
}

