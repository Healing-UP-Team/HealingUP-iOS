//
//  HealingUP_iOSApp.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 23/05/22.
//

import SwiftUI
import Firebase
import FirebaseMessaging

@main
struct HealingUP_iOSApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  let persistenceController = PersistenceController.shared

  private var isSignedIn: Bool = false
  private let navigator: HomeNavigator = AppAssembler.shared.resolve()

  init() {
    FirebaseApp.configure()
    isSignedIn = DefaultFirebaseManager.shared.firebaseAuth.currentUser != nil
  }

  var body: some Scene {
    WindowGroup {
      ContentView(isSignedIn: isSignedIn, navigator: navigator)
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
        .environmentObject(NavigationHelper())
    }
  }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    MembershipViewModel.shared.setupUserData()
    NotificationService.register(application: application)

    return true
  }

  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("Unable to register for remote notifications: \(error.localizedDescription)")
  }

  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    print("APNs token retrieved: \(deviceToken)")
  }
}
