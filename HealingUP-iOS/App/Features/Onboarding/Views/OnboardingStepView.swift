//
//  OnboardingStepView.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 14/07/22.
//

import SwiftUI

struct OnboardingStepView: View {
  var data: Onboarding
  var body: some View {
    VStack {
      Image(data.image)
        .resizable()
        .scaledToFit()
        .padding(.bottom, 50)
      Text(data.heading)
        .font(.system(size: 25, design: .rounded))
        .fontWeight(.bold)
        .padding(.bottom, 20)
      Text(data.text)
        .font(.system(size: 17, design: .rounded))
        .fontWeight(.medium)
        .multilineTextAlignment(.center)
    }
    .padding()
    .contentShape(Rectangle())
  }
}

struct OnboardingStepView_Previews: PreviewProvider {
  static var previews: some View {
    OnboardingStepView(data: Onboarding.data[0])
  }
}
