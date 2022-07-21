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
  var backgroundColor: Color? = .accentColor
  var titleColor: Color? = .white

  init(title: String, action: @escaping () -> Void, backgroundColor: Color? = Color.accentColor, titleColor: Color? = .white) {
    self.title = title
    self.action = action
    self.backgroundColor = backgroundColor
    self.titleColor = titleColor
  }

  var body: some View {
    Button(action: action, label: {
      Text(title)
        .frame(width: UIScreen.main.bounds.width/1.3, height: 30, alignment: .center)
        .foregroundColor(titleColor ?? .white)
        .font(.system(size: 16, weight: .bold))
        .padding()
        .background(backgroundColor ?? Color.accentColor)
        .cornerRadius(12)
    })
  }
}

struct ButtonDefaultView_Previews: PreviewProvider {
  static var previews: some View {
    ButtonDefaultView(title: "Save", action: {})
  }
}
