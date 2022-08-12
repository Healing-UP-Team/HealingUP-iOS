//
//  EmptyView.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 12/08/22.
//

import SwiftUI

struct EmptyStateView: View {
  let image: UIImage
  let title: String
  let message: String
  
    var body: some View {
      VStack(alignment: .center) {
        Spacer()
        Image(uiImage: .kesslerIntro)
          .resizable()
          .scaledToFit()
          .frame(height: 250)
          .padding()
        VStack(alignment: .center) {
          Text(title)
            .font(.system(size: 30, weight: .bold))
            .foregroundColor(Color.accentColor)
            .padding(.top, 10)
            .padding(.bottom, 10)
            .padding(.horizontal)
            .multilineTextAlignment(.center)
          Text(message)
            .foregroundColor(Color.accentColor)
            .padding(.horizontal)
            .multilineTextAlignment(.center)
        }
        Spacer()
      }
    }
}

struct EmptyStateView_Previews: PreviewProvider {
    static var previews: some View {
      EmptyStateView(image: .kesslerIntro, title: "Tidak ada riwayat", message: "Sepertinya kamu belum mengukur tingkat stres sebelumnya")
    }
}

