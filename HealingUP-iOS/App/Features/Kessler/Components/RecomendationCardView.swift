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

  var backgroundColor: Color {
    switch self {
    case .breathing:
      return Color(uiColor: .softBlue)
    case .journaling:
      return Color(uiColor: .softYellow)
    case .counseling:
      return Color(uiColor: .softPinkSecond)
    }
  }
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
          .foregroundColor(Color(uiColor: .accentPurple))
        VStack(alignment: .leading, spacing: 10) {
          Text(stressHandling.title ?? "Deep Breathing")
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(Color(uiColor: .accentPurple))
          Text(stressHandling.caption ?? "Express your feelings in writing")
            .font(.system(size: 10, weight: .regular))
            .fixedSize(horizontal: false, vertical: true)
            .foregroundColor(Color(uiColor: .accentPurple))
        }
        Spacer()
        Image(systemName: "chevron.right")
          .foregroundColor(Color(uiColor: .accentPurple))
      }
      .padding()
      .background(
        stressHandling.type?.backgroundColor
      )
      .cornerRadius(10)
    }
}

struct RecomendationCardView_Previews: PreviewProvider {
    static var previews: some View {
      RecomendationCardView(stressHandling: StressHandling(title: "Deep Breathing", caption: "Latihan bernapas menggunakan teknik pernapasan dalam", img: "nose", type: .breathing))
    }
}
