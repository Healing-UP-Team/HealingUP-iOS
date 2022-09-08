//
//  Color.swift
//  HealingUP-iOS
//
//  Created by Muhammad Rifki Widadi on 13/07/22.
//

import SwiftUI

extension Color {

    static var primaryWhite = Color(uiColor: UIColor.primaryWhite)
    static var accentPurple = Color(uiColor: UIColor.accentPurple)
    static var softYellow = Color(uiColor: UIColor.softYellow)
    static var softPinkSecond = Color(uiColor: UIColor.softPinkSecond)
    static var softBlue = Color(uiColor: UIColor.softBlue)
    static var softPinkFirst = Color(uiColor: UIColor.softPinkFirst)
    static var softGray = Color("SoftGray")

    static var combColor: [String: Color] = [
        "😔": .accentPurple,
        "🙂": .softPinkFirst,
        "😊": Color.gray.opacity(0.2),
        "😁": .softBlue,
        "😆": .softPinkSecond
    ]
}
