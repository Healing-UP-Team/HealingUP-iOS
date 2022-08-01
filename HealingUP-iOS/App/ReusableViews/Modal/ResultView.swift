//
//  ResultView.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 20/07/22.
//

import SwiftUI

struct ResultView: View {
  let title: String?
  let icon: UIImage?
  let message: String?
  let buttonTitle: String?
  let buttonAction: (() -> Void)?
  @Environment(\.presentationMode) var presentationMode

  var body: some View {
    VStack {
      Spacer()
      Text(title ?? "Berhasil")
        .font(.system(size: 30, weight: .bold))
        .foregroundColor(Color(uiColor: .accentPurple))
        .multilineTextAlignment(.center)
      Spacer()
      Image(uiImage: icon ?? .icSuccess)
        .resizable()
        .scaledToFit()
        .frame(width: 300)
      Spacer()
      Text(message ?? "")
        .font(.system(size: 15, weight: .medium))
        .foregroundColor(Color.gray)
        .multilineTextAlignment(.center)
        .padding(.horizontal)
      Spacer()
      ButtonDefaultView(title: buttonTitle ?? "OK", action: {
        presentationMode.wrappedValue.dismiss()
        buttonAction?()
      })
    }.padding()
  }
}

struct ResultView_Previews: PreviewProvider {
  static var previews: some View {
    ResultView(title: "Berhasil", icon: .icSuccess, message: "Kamu bisa", buttonTitle: "OK", buttonAction: {})
  }
}
