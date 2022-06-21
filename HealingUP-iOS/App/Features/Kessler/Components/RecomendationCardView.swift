//
//  RecomendationCardView.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 21/06/22.
//

import SwiftUI

enum StressHandlingType {
  case breathing
  case journaling
  case counseling
}

struct StressHandling: Hashable {
  var title: String?
  var caption: String?
  var img: String?
  var type: StressHandlingType?
}

struct RecomendationCardView: View {
  let stressHandling: StressHandling
    var body: some View {
      HStack {
        Image(systemName: stressHandling.img ?? "nose")
          .font(.system(size: 60))
          .frame(width: 90, height: 90, alignment: .center)
          .foregroundColor(.blue)
        VStack(alignment: .leading, spacing: 10) {
          Text(stressHandling.title ?? "Deep Breathing")
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(Color.blue)
          Text(stressHandling.caption ?? "Lorem Ipsum")
            .font(.system(size: 15, weight: .regular))
            .foregroundColor(.gray)
        }
        Spacer()
        Image(systemName: "chevron.right")
      }
      .padding()
      .background(Color.white)
      .cornerRadius(10)
      .shadow(color: Color.black.opacity(0.5), radius: 2, x: 0, y: 0)
    }
}

struct RecomendationCardView_Previews: PreviewProvider {
    static var previews: some View {
      RecomendationCardView(stressHandling: StressHandling(title: "Deep Breathing", caption: "Lorem Ipsum", img: "nose", type: .breathing))
    }
}
