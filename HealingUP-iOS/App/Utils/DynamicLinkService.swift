//
//  DynamicLinkService.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 20/07/22.
//

import Foundation
import FirebaseDynamicLinks
import UIKit

extension DynamicLinksService {
  enum DynamicLinkTarget {
    case scheduleDetail(id: String)
  }

  struct SocialMetaTag {
    let title       = "Healing UP"
    let description = "Teman Curhatmu"
    let imageURL    = URL(string: "https://via.placeholder.com/300")!
  }
}

final class DynamicLinksService: ObservableObject {
  @Published var dynamicLinkTarget: DynamicLinkTarget?

  static let shared = DynamicLinksService()

  private init() {}

  private func shortenURL(linkBuilder: DynamicLinkComponents, completionHandler: ((URL) -> Void)? = nil) {
    linkBuilder.shorten { url, _, _ in
      guard let url = url else { return }
      completionHandler?(url)
    }
  }

  func generateDynamicLink(
    scheduleId: String,
    metaTag: SocialMetaTag = SocialMetaTag(),
    completionHandler: ((String) -> Void)? = nil
  ) {
    guard let linkBuilder = createLinkBuilder(scheduleID: scheduleId, metaTag: metaTag) else { return }
    shortenURL(linkBuilder: linkBuilder) { url in
      completionHandler?(url.absoluteString)
    }
  }

  func handleNotification(userInfo: [AnyHashable: Any]) {
    guard
      let deepLink = userInfo["deepLink"] as? String,
      let deepLinkURL = URL(string: deepLink)
    else { return }

    DynamicLinks.dynamicLinks().handleUniversalLink(deepLinkURL) { dynamicLink, _ in
      guard let dynamicLink = dynamicLink else { return }
      DynamicLinksService.shared.handleDynamicLink(dynamicLink: dynamicLink)
    }
  }

  func handleDynamicLink(dynamicLink: DynamicLink) {
    guard let url = dynamicLink.url,
          url.scheme == "https",
          let query = url.query
    else { return }

    let components = query.split(separator: ",").flatMap { substring in
      substring.split(separator: "=")
    }

    guard let scheduleIDKeyIndex = components.firstIndex(of: Substring("schedule_id")),
          scheduleIDKeyIndex + 1 < components.count
    else { return }

    let bookingID = String(components[scheduleIDKeyIndex + 1])

    dynamicLinkTarget = .scheduleDetail(id: bookingID)
  }

  private func createQueryItems(for target: DynamicLinkTarget) -> URLQueryItem? {
    if case .scheduleDetail(let scheduleID) = target {
      return URLQueryItem(name: "schedule_id", value: scheduleID)
    }

    return nil
  }

  private func createURLComponents(for target: DynamicLinkTarget) -> URLComponents? {
    var component = URLComponents()
    guard let queryItem = createQueryItems(for: target) else { return nil }

    component.scheme        = "https"
    component.host          = "healingup.page.link"
    component.queryItems    = [queryItem]

    return component

  }

  private func createLinkBuilder(scheduleID: String, metaTag: SocialMetaTag) -> DynamicLinkComponents? {
    let urlComponent = createURLComponents(for: .scheduleDetail(id: scheduleID))

    guard let link = urlComponent?.url,
          let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: "https://healingup.page.link") else { return nil }

    if let mokuBundleId = Bundle.main.bundleIdentifier {
      linkBuilder.iOSParameters = DynamicLinkIOSParameters(bundleID: mokuBundleId)
    }

    linkBuilder.iOSParameters?.appStoreID                   = "270400002"
    linkBuilder.socialMetaTagParameters                     = DynamicLinkSocialMetaTagParameters()
    linkBuilder.socialMetaTagParameters?.title              = metaTag.title
    linkBuilder.socialMetaTagParameters?.descriptionText    = metaTag.description
    linkBuilder.socialMetaTagParameters?.imageURL           = metaTag.imageURL

    return linkBuilder
  }
}
