//
//  HealingUP_iOSApp.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 23/05/22.
//

import SwiftUI
import Firebase

@main
struct HealingUP_iOSApp: App {
  let persistenceController = PersistenceController.shared

  private var isSignedIn: Bool = false
  private let navigator: HomeNavigator = AppAssembler.shared.resolve()

  init() {
    FirebaseApp.configure()
//    do {
//      try FirebaseAuth.Auth.auth().signOut()
//    } catch {
//      print("error")
//    }

    isSignedIn = DefaultFirebaseManager.shared.firebaseAuth.currentUser != nil
  }

  var body: some Scene {
    WindowGroup {
      ContentView(isSignedIn: isSignedIn, navigator: navigator)
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
  }
}
