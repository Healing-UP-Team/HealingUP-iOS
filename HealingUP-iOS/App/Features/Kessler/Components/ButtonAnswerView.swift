//
//  ButtonAnswerView.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 06/06/22.
//

import SwiftUI

struct ButtonAnswerView: View {
  let text: String
  let action: () -> Void
    var body: some View {
      Button {
        action()
      }label: {
        Text(text)
          .font(.system(size: 18, weight: .bold))
          .foregroundColor(.accentColor)
          .frame(width: UIScreen.main.bounds.width/1.3, height: 20, alignment: .center)
          .padding()
          .background(Color(uiColor: .softBlue))
          .cornerRadius(12)
      }

    }
}

struct ButtonAnswerView_Previews: PreviewProvider {
    static var previews: some View {
      ButtonAnswerView(text: "None of the time", action: {})
    }
}
