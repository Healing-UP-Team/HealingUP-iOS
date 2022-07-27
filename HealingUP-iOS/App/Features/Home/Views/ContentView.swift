//
//  ContentView.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 23/05/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
  let isSignedIn: Bool
  let navigator: HomeNavigator
  @State private var onboardingDone = false
  var data = Onboarding.data

  var body: some View {
    ZStack {
      if SessionManager.isFirstInstall() {
        navigator.navigateToOnboarding(data: data, doneFuntion: {
          SessionManager.setNotFirstInstall()
          onboardingDone = true
        })
      } else {
        if isSignedIn {
          if SessionManager.isCounsellor() {
            navigator.navigateToHomeCounsellor()
          } else {
            navigator.navigateToHome()
          }
        } else {
          navigator.navigateToSignIn()
        }
      }
    }
    .fullScreenCover(isPresented: $onboardingDone) {
      navigator.navigateToSignIn()
    }
  }
}
