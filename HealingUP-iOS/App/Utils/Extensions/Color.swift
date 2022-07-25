//
//  Color.swift
//  HealingUP-iOS
//
//  Created by Muhammad Rifki Widadi on 13/07/22.
//

import SwiftUI

extension Color {
    /**static let primaryWhite = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
     static let accentPurple = UIColor(red: 97, green: 94, blue: 168, alpha: 1)

     //MARK: Kessler History
     static let softYellow = UIColor(red: 251, green: 229, blue: 161, alpha: 1)
     static let softPinkSecond = UIColor(red: 251, green: 231, blue: 216, alpha: 1)
     static let softBlue = UIColor(red: 232, green: 240, blue: 251, alpha: 1)
     static let softPinkFirst = UIColor(red: 245, green: 191, blue: 194, alpha: 1)*/

    static var primaryWhite = Color(uiColor: UIColor.primaryWhite)
    static var accentPurple = Color(uiColor: UIColor.accentPurple)
    static var softYellow = Color(uiColor: UIColor.softYellow)
    static var softPinkSecond = Color(uiColor: UIColor.softPinkSecond)
    static var softBlue = Color(uiColor: UIColor.softBlue)
    static var softPinkFirst = Color(uiColor: UIColor.softPinkFirst)

    static var combColor : [String: Color] = [
        "😔": .accentPurple,
        "🙂": .softPinkFirst,
        "😊": Color.gray.opacity(0.2),
        "😁": .softBlue,
        "😆": .softPinkSecond
    ]
}
