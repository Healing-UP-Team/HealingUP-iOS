//
//  JournalModel.swift
//  Semhas
//
//  Created by Muhammad Rifki Widadi on 30/06/22.
//

import Foundation

struct Journal: Codable, Identifiable {
    var id = UUID()
    var emoji: String
    var title: String
    var note: String
    var date: String
}
