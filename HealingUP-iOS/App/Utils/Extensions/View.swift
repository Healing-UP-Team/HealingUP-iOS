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

extension View {
  func setDefaultTabBarView() {
    let image = UIImage.gradientImageWithBounds(
        bounds: CGRect( x: 0, y: 0, width: UIScreen.main.scale, height: 5),
        colors: [
            UIColor.clear.cgColor,
            UIColor.gray.withAlphaComponent(0.1).cgColor
        ]
    )

    let appearance = UITabBarAppearance()
    appearance.configureWithTransparentBackground()
    appearance.backgroundColor = UIColor.systemGray6
            
    appearance.backgroundImage = UIImage()
    appearance.shadowImage = image

    UITabBar.appearance().standardAppearance = appearance
  }
  
  func setDefaultNavigationBar() {
    let navigationAppearance = UINavigationBarAppearance()
    
    navigationAppearance.configureWithOpaqueBackground()
    navigationAppearance.titleTextAttributes = [.foregroundColor: UIColor.accentPurple]
    navigationAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.accentPurple]
    navigationAppearance.backgroundColor = .white
    navigationAppearance.shadowColor = .clear
    navigationAppearance.shadowImage = UIImage()
    
    let apperanceScroll = UINavigationBarAppearance()
    
    apperanceScroll.configureWithOpaqueBackground()
    apperanceScroll.titleTextAttributes = [.foregroundColor: UIColor.accentPurple]
    apperanceScroll.largeTitleTextAttributes = [.foregroundColor: UIColor.accentPurple]
  
    UINavigationBar.appearance().standardAppearance = apperanceScroll
    UINavigationBar.appearance().compactAppearance = apperanceScroll
    UINavigationBar.appearance().scrollEdgeAppearance = navigationAppearance
    
  }
}
