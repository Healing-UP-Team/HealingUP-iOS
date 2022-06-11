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
          Text(kesslerResult.createAt.toStringWith(format: "EE, dd-MM-yyyy") ?? "")
            .foregroundColor(.white)
            .font(.system(size: 18, weight: .medium))
            .padding(.bottom, 5)
          
          Text(kesslerResult.stressLevel.rawValue)
            .foregroundColor(.white)
            .font(.system(size: 25, weight: .bold))
        }
        Spacer()
      }
      .frame(width: UIScreen.main.bounds.width/1.2, alignment: .center)
      .padding()
      .background(Color.cyan)
      .cornerRadius(10)
    }
}

struct KesslerResultItemView_Previews: PreviewProvider {
    static var previews: some View {
      KesslerResultItemView(kesslerResult: KesslerResult( stressLevel: .moderate, createAt: Date()))
    }
}
