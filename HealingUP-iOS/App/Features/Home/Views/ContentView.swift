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

  var body: some View {
    ZStack {
      if isSignedIn {
        navigator.navigateToHome()
      } else {
        navigator.navigateToSignIn()
      }
    }
  }
}
