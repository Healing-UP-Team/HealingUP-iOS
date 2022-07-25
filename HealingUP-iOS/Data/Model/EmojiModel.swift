//
//  EmojiModel.swift
//  Semhas
//
//  Created by Muhammad Rifki Widadi on 13/07/22.
//

import Foundation

struct Emotion: Codable, Identifiable, Hashable {
    var id = UUID()
    var emoji: String
    var desc: String
}

extension Emotion {
    static var data = [
        Emotion(emoji: "😔", desc: "Sedih"),
        Emotion(emoji: "🙂", desc: "Cukup Sedih"),
        Emotion(emoji: "😊", desc: "Cukup Senang"),
        Emotion(emoji: "😁", desc: "Senang"),
        Emotion(emoji: "😆", desc: "Senang Sekali"),
    ]
}
