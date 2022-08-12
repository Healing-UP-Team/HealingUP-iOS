//
//  KesslerResultItemView.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 06/06/22.
//

import SwiftUI

struct KesslerResultItemView: View {
  let kesslerResult: KesslerResult

    var body: some View {
      HStack {
        VStack(alignment: .leading) {
          HStack(alignment: .center) {
            Image(systemName: "calendar")
              .foregroundColor(Color(uiColor: .accentPurple))
              .font(.system(size: 13))
            Text(kesslerResult.createAt.toStringWith(format: "EE, dd MMM yyyy") ?? "")
              .foregroundColor(Color(uiColor: .accentPurple))
              .font(.system(size: 10, weight: .medium))
          }
          .padding(.bottom, 5)
          Text(kesslerResult.stressLevel.rawValue)
            .foregroundColor(Color(uiColor: .accentPurple))
            .font(.system(size: 15, weight: .bold))
        }
        Spacer()
      }
      .frame(width: UIScreen.main.bounds.width/1.2, alignment: .center)
      .padding()
      .background(kesslerResult.stressLevel.backgroundColor)
      .cornerRadius(10)
    }
}

struct KesslerResultItemView_Previews: PreviewProvider {
    static var previews: some View {
      KesslerResultItemView(kesslerResult: KesslerResult( stressLevel: .moderate, createAt: Date()))
    }
}
