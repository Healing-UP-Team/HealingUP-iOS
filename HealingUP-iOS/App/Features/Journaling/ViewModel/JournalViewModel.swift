//
//  JournalViewModel.swift
//  Semhas
//
//  Created by Muhammad Rifki Widadi on 13/07/22.
//

import Combine

class JournalViewModel: ObservableObject {
    @Published var journal: [Journal] = Journal.data

    @Published var emoji: Emotion = .data[0]


}

