//
//  KesslerQuiz.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 06/06/22.
//

import SwiftUI

struct KesslerQuizView: View {
  let navigator: KesslerNavigator
  @State var kesslerQuiz: [KesslerQuiz]
  @State var i: Int = 0
  @State var score = 0
  @State private var isDone = false
  var isFirstTime: Binding<Bool>?
  
    var body: some View {
      VStack {
        if self.i < kesslerQuiz.count {
          Text(kesslerQuiz[self.i].question)
            .font(.system(size: 25, weight: .bold))
            .padding()
            .multilineTextAlignment(.center)
          Spacer()
          VStack {
            ForEach(kesslerQuiz[self.i].answer.indices) { index in
              ButtonAnswerView(text: kesslerQuiz[self.i].answer[index], action: {
                buttonAction(n: index)
              })
            }
          }
        }
      }
      .padding()
      .fullScreenCover(isPresented: $isDone, onDismiss: {
        isFirstTime?.wrappedValue = false
      }) { navigator.navigateToKesslerFinalView(score: self.score) }
    }
  
  private func buttonAction(n: Int) {
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
    
    if self.i < kesslerQuiz.count-1 {
      self.i = self.i + 1
    } else {
      isDone = true
    }
  }

}

struct KesslerQuiz_Previews: PreviewProvider {
    static var previews: some View {
      KesslerQuizView(navigator: AppAssembler.shared.resolve(), kesslerQuiz: [
        KesslerQuiz(question: "In the past 4 weeks, about how often did you feel tired out for no good reason?", answer: ["None of the time", "A little of the time", "Some of the time", "Most of the time", "All of the time"])
      ])
    }
}
