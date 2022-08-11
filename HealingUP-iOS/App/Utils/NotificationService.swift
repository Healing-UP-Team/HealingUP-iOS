//
//  NotificationService.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 20/07/22.
//

import FirebaseMessaging
import UserNotifications
import UIKit

final class NotificationService: NSObject, ObservableObject {
  struct Content: Codable {
    var title: String
    var body: String
  }

  enum Notification {
    case schedulePlaced
    case scheduleCanceled(_ reason: String)
    case updateScheduleStatus(_ status: ScheduleStatus)

    var content: Content {
      switch self {
      case .schedulePlaced:
        return Content(title: "Hi, Ada Pasien yang Membutuhkanmu!", body: "Silahkan cek jadwal yang diajukan.")
      case .scheduleCanceled(let reason):
        return Content(title: "Yah, Jadwal Ditolak!", body: reason)
      case .updateScheduleStatus(let status):
        return Content(title: "Cek Status Jadwal Konselingmu", body: "Status permintaan anda sudah di Perbarui menjadi \(status.rawValue)")
      }
    }
  }

  static let shared = NotificationService()
  let viewModel = MembershipViewModel.shared

  private override init() {}

  static func register(application: UIApplication) {
    Messaging.messaging().delegate = shared
    
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = shared
      
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: {_, _ in })
    } else {
      let settings: UIUserNotificationSettings =
      UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
    }
    
    application.registerForRemoteNotifications()
  }

  func getToken(completionHandler: ((String) -> Void)? = nil) {
    Messaging.messaging().token { token, _ in
      if let token = token { completionHandler?(token) }
    }
  }

  func send(to identifiers: [String], notification: Notification, imageUrl: String? = nil, withUrl url: String? = nil) {
    // MARK: JSON Data
    var json: [String: Any] = [
      "content_available": true,
      "mutable_content": true,
      "registration_ids": identifiers,
      "priority": "high",
      "notification": [
        "title": notification.content.title,
        "body": notification.content.body,
        "sound": "default"
      ]
    ]

    if let deepLink = url {
      json["data"] = [ "deepLink": deepLink ]
    }

    if let imageUrl = imageUrl {
      json["data"] = [ "imageUrl": imageUrl ]
    }

    let jsonData = try? JSONSerialization.data(withJSONObject: json)

    let url = URL(string: "https://fcm.googleapis.com/fcm/send")!
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue(
      "key=AAAALJZ_JMg:APA91bE9gGkMF-t1c8JSzZpFAdsGNAUtByPZEihpahxDkSCn6GR6-hGmxCwHJ5wCzSmf780o_K-6A5MJA3rsWhsgLiYaZ-Y3J8sAn_hE9Mfo30G02q53HyHEEi5VyCnWhXABmsv-uq36",
      forHTTPHeaderField: "Authorization"
    )
    request.httpMethod = "POST"
    request.httpBody = jsonData

    URLSession.shared.dataTask(with: request) { _, _, _  in }.resume()
  }
}

extension NotificationService: UNUserNotificationCenterDelegate {
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    completionHandler([[.badge, .banner, .sound]])
  }

  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    let userInfo = response.notification.request.content.userInfo

    DynamicLinksService.shared.handleNotification(userInfo: userInfo)

    completionHandler()
  }
}

extension NotificationService: MessagingDelegate {
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    if let fcmToken = fcmToken {
      if var currentUser: User = MembershipViewModel.shared.userData {
        currentUser.fcmToken = fcmToken
        viewModel.updateUser(user: currentUser)
      }
    }
  }
}
