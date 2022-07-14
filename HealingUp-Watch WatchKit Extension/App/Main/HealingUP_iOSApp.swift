//
//  HealingUP_iOSApp.swift
//  HealingUp-Watch WatchKit Extension
//
//  Created by Dicky Buwono on 24/05/22.
//

import SwiftUI
import Combine

@main
struct HealingUP_iOSApp: App {
  @State var loggedIn = false
  @ObservedObject var heartViewModel = HeartRateViewModel()
  @ObservedObject var session = SessionManager.shared

  init() {

  }

  var body: some Scene {
    WindowGroup {
      if session.islogin {
        NavigationView {
          ContentView()
        }
      } else {
        NotLoginStateView()
      }
    }
  }

}
