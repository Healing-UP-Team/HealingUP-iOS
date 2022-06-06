//
//  View.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 06/06/22.
//

import SwiftUI

extension View {
  func progressHUD(
    isShowing: Binding<Bool>,
    type: ProgressHUDType = .default,
    isBlurBackground: Bool = true
  ) -> some View {
    ProgressHUDModifier(
      isShowing: isShowing,
      type: type,
      isBlurBackground: isBlurBackground,
      presenting: { self }
    )
  }
}
