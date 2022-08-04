//
//  JournalModel.swift
//  Semhas
//
//  Created by Muhammad Rifki Widadi on 30/06/22.
//

import Foundation
import FirebaseFirestoreSwift

struct Journal: Identifiable, Codable {
    @DocumentID var id: String?
    var userId: String?
    var emoji: String
    var title: String
    var note: String
    var date: Date

  enum CodingKeys: String, CodingKey {
    case id
    case userId
    case emoji
    case title
    case note
    case date
  }
}
