//
//  ButtonDefaultView.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 06/07/22.
//

import SwiftUI

struct ButtonDefaultView: View {
  let title: String
  let action: () -> Void

  var body: some View {
    Button(action: action, label: {
      Text(title)
        .frame(width: UIScreen.main.bounds.width/1.3, height: 30, alignment: .center)
        .foregroundColor(.white)
        .font(.system(size: 16, weight: .bold))
        .padding()
        .background(Color.accentColor)
        .cornerRadius(12)
    })
  }
}

struct ButtonDefaultView_Previews: PreviewProvider {
  static var previews: some View {
    ButtonDefaultView(title: "Save", action: {})
  }
}
