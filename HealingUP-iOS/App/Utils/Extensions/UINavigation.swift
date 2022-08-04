//
//  UINavigation.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 04/08/22.
//

import SwiftUI

extension UINavigationController {
  open override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    navigationBar.topItem?.backButtonDisplayMode = .minimal
  }
}
