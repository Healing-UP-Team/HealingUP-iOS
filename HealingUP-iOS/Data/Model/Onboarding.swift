//
//  Onboarding.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 14/07/22.
//

import SwiftUI

struct Onboarding {
    var image: String
    var heading: String
    var text: String
}

extension Onboarding {
    static var data: [Onboarding] = [
      Onboarding(image: "img-kessler-intro", heading: "Welcome to Healing UP", text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."),
      Onboarding(image: "img-kessler-intro", heading: "Explore the Stress", text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."),
      Onboarding(image: "img-kessler-intro", heading: "Life must be go on", text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
    ]
}
