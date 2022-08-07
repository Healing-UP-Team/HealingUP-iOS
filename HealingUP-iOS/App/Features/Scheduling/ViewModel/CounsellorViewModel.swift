//
//  CounsellorViewModel.swift
//  HealingUP-iOS
//
//  Created by Muhammad Rifki Widadi on 07/08/22.
//

import Combine
import FirebaseFirestore

class CounsellorViewModel: ObservableObject {
  @Published var link = ""
  private var db = Firestore.firestore()
  private let path = "schedule"


  func updateScheduleCounsellor(_ scheduleId: String) {
    db.collection(path).document(scheduleId).updateData(["link_meeting": self.link]) { error in
      if let error = error {
        print(error.localizedDescription)
      }
    }
  }

  func updateStatusScheduelingToDone(_ scheduleId: String) {
    db.collection(path).document(scheduleId).updateData(["status": "Selesai"]) { error in
      if let error = error {
        print(error.localizedDescription)
      }
    }
  }
}
