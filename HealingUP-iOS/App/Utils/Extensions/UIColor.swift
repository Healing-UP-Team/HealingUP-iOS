//
//  UIColor.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 06/07/22.
//

import SwiftUI

extension UIColor {
  convenience init(red: Int, green: Int, blue: Int, alpha: Int = 1) {
    assert(red >= 0 && red <= 255, "Invalid red component")
    assert(green >= 0 && green <= 255, "Invalid green component")
    assert(blue >= 0 && blue <= 255, "Invalid blue component")

    self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha))
  }

  convenience init(netHex: Int) {
    self.init(red: (netHex >> 16) & 0xff, green: (netHex >> 8) & 0xff, blue: netHex & 0xff)
  }

  convenience init?(hex: String) {
    let r, g, b, a: CGFloat

    if hex.hasPrefix("#") {
      let start = hex.index(hex.startIndex, offsetBy: 1)
      let hexColor = String(hex[start...])

      if hexColor.count == 8 {
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0

        if scanner.scanHexInt64(&hexNumber) {
          r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
          g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
          b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
          a = CGFloat(hexNumber & 0x000000ff) / 255

          self.init(red: r, green: g, blue: b, alpha: a)
          return
        }
      }
    }

    return nil
  }

  static let primaryWhite = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
  static let accentPurple = UIColor(red: 97, green: 94, blue: 168, alpha: 1)

  // MARK: Kessler History
  static let softYellow = UIColor(red: 251, green: 229, blue: 161, alpha: 1)
  static let softPinkSecond = UIColor(red: 251, green: 231, blue: 216, alpha: 1)
  static let softBlue = UIColor(red: 232, green: 240, blue: 251, alpha: 1)
  static let softPinkFirst = UIColor(red: 245, green: 191, blue: 194, alpha: 1)

}

extension UIColor {
  static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
    guard #available(iOS 13.0, *) else { return light }
    return UIColor { $0.userInterfaceStyle == .dark ? dark : light }
  }
}
