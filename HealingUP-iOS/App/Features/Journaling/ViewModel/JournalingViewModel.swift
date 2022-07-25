//
//  JournalingViewModel.swift
//  HealingUP-iOS
//
//  Created by Muhammad Rifki Widadi on 12/07/22.
//

import Foundation

class JournalingViewModel: ObservableObject {
    private let firebaseManager: FirebaseManager

    init(firebaseManager: FirebaseManager) {
      self.firebaseManager = firebaseManager
    }

}
