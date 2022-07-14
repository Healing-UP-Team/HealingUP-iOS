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
  @State private var isDone = false
  @State var uiTabarController: UITabBarController?
  @StateObject var kesslerViewModel = KesslerViewModel(firebaseManager: AppAssembler.shared.resolve())

  var isBackToRoot: Binding<Bool>?

  var body: some View {
    VStack {
      VStack(alignment: .leading, spacing: 0) {
        HStack(alignment: .bottom, spacing: 5) {
          Text("Question")
            .font(.system(size: 20, weight: .semibold))
            .foregroundColor(Color.accentColor)
          Text("\(i+1)/10")
            .font(.system(size: 25, weight: .semibold))
            .foregroundColor(Color.accentColor)
        }
        ProgressView(value: Double(i+1), total: 10)
          .padding(.vertical)
          .tint(Color.accentColor)
      }
      Spacer()
      if self.i < kesslerQuiz.count {
        Text(kesslerQuiz[self.i].question)
          .font(.system(size: 25, weight: .bold))
          .foregroundColor(Color.accentColor)
          .padding()
          .multilineTextAlignment(.leading)
        Spacer()
        VStack {
          ForEach(kesslerQuiz[self.i].answer.indices, id: \.self) { index in
            ButtonAnswerView(text: kesslerQuiz[self.i].answer[index], action: {
              buttonAction(n: index)
            })
          }
        }
      }
    }
    .padding()
    .navigationBarTitle("")
    .navigationBarTitleDisplayMode(.inline)
    .introspectTabBarController { (UITabBarController) in
      UITabBarController.tabBar.isHidden = true
      uiTabarController = UITabBarController
    }
    .fullScreenCover(isPresented: $isDone, onDismiss: {
      isBackToRoot?.wrappedValue = false
    }) {
      navigator.navigateToKesslerFinalView(score: kesslerViewModel.score)
    }
    .onAppear {
      self.kesslerViewModel.score = 0
    }
  }

  private func buttonAction(n: Int) {
    if n == 0 {
      self.kesslerViewModel.score += 1
    } else if n == 1 {
      self.kesslerViewModel.score += 2
    } else if n == 2 {
      self.kesslerViewModel.score += 3
    } else if n == 3 {
      self.kesslerViewModel.score += 4
    } else {
      self.kesslerViewModel.score += 5
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
    ], kesslerViewModel: AppAssembler.shared.resolve())
  }
}
