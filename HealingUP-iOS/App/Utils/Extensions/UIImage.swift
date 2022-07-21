//
//  UIImage.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 06/07/22.
//

import SwiftUI

extension UIImage {

  // MARK: Kessler
  static let kesslerIntro = UIImage(named: "img-kessler-intro")!
  static let appIcon = UIImage(named: "healingUpIcon")!

  // MARK: Schedule
  static let icSuccess = UIImage(named: "ic-success")!
  static let icXmark = UIImage(named: "ic-xmark")!

}

extension UIImage {
    static func gradientImageWithBounds(bounds: CGRect, colors: [CGColor]) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors

        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
