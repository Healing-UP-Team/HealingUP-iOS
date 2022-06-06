//
//  KesslerQuiz.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 06/06/22.
//

import SwiftUI

struct KesslerQuizView: View {
  @State var kesslerQuiz: [KesslerQuiz]
  @State var i: Int = 0
  @State var score = 0
    var body: some View {
      VStack {
        if self.i < kesslerQuiz.count {
          Text(kesslerQuiz[self.i].question)
          VStack {
            ForEach(kesslerQuiz[self.i].answer.indices) { index in
              ButtonAnswerView(text: kesslerQuiz[self.i].answer[index], action: {
                buttonAction(n: index)
              })
            }
          }
        } else {
          KesslerFinalView(score: self.score)
        }
        
      }
    }
  
  func buttonAction(n: Int) {
    if n == 0 {
      self.score = self.score + 1
    } else if n == 1 {
      self.score = self.score + 2
    } else if n == 2 {
      self.score = self.score + 3
    } else if n == 3 {
      self.score = self.score + 4
    } else {
      self.score = self.score + 5
    }
    
    self.i = self.i + 1
  }

}

struct ButtonAnswerView: View {
  let text: String
  let action: () -> Void
  var body: some View {
    Button {
      action()
    }label: {
      Text(text)
    }
  }
}
              


struct KesslerQuiz_Previews: PreviewProvider {
    static var previews: some View {
      KesslerQuizView(kesslerQuiz: [KesslerQuiz]())
    }
}
