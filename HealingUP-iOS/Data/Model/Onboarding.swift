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
      Onboarding(image: "img-kessler-intro", heading: "HealingUp", text: "Kamu dapat menggunakan aplikasi HealingUp untuk mengukur tingkat stres kamu dan melakukan penanganan yang akan kami rekomendasikan"),
      Onboarding(image: "img-counseling", heading: "Buat Jadwal Konseling", text: "Kamu dapat membuat jadwal konseling online dengan psikolog pilihan kamu."),
      Onboarding(image: "img-watch", heading: "Pernapasan Perut", text: "Kamu dapat melakukan latihan pernapasan perut dengan menggunakan aplikasi HealingUp pada Apple Watch.")
    ]
}
