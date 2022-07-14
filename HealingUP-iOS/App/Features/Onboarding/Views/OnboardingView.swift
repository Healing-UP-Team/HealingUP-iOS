//
//  OnboardingView.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 14/07/22.
//

import SwiftUI

struct OnboardingView: View {

  @State var slideGesture: CGSize = CGSize.zero
  @State var curSlideIndex = 0

  let data: [Onboarding]
  var doneFunction: () -> Void
  var distance: CGFloat = UIScreen.main.bounds.size.width

  func nextButton() {
    if self.curSlideIndex == self.data.count - 1 {
      doneFunction()
      return
    }

    if self.curSlideIndex < self.data.count - 1 {
      withAnimation {
        self.curSlideIndex += 1
      }
    }
  }

  var body: some View {
    ZStack {
      Color(.systemBackground).edgesIgnoringSafeArea(.all)

      ZStack(alignment: .center) {
        withAnimation(.spring()) {
          ForEach(0..<data.count, id: \.self) { i in
            OnboardingStepView(data: self.data[i])
              .offset(x: CGFloat(i) * self.distance)
              .offset(x: self.slideGesture.width - CGFloat(self.curSlideIndex) * self.distance)
              .gesture(DragGesture().onChanged { value in
                self.slideGesture = value.translation
              }
                .onEnded { _ in
                  if self.slideGesture.width < -50 {
                    if self.curSlideIndex < self.data.count - 1 {
                      withAnimation {
                        self.curSlideIndex += 1
                      }
                    }
                  }
                  if self.slideGesture.width > 50 {
                    if self.curSlideIndex > 0 {
                      withAnimation {
                        self.curSlideIndex -= 1
                      }
                    }
                  }
                  self.slideGesture = .zero
                })
          }
        }
      }

      VStack {
        Spacer()
        HStack {
          self.progressView()
          Spacer()
          Button(action: nextButton) {
            self.arrowView()
          }
        }
      }
      .padding(20)
    }
  }

  func arrowView() -> some View {
    Group {
      if self.curSlideIndex == self.data.count - 1 {
        HStack {
          Text("Done")
            .font(.system(size: 27, weight: .medium, design: .rounded))
            .foregroundColor(Color(.systemBackground))
        }
        .frame(width: 120, height: 50)
        .background(Color(.label))
        .cornerRadius(25)
      } else {
        Image(systemName: "arrow.right.circle.fill")
          .resizable()
          .foregroundColor(Color(.label))
          .scaledToFit()
          .frame(width: 50)
      }
    }
  }

  func progressView() -> some View {
    HStack {
      ForEach(0..<data.count, id: \.self) { i in
        Circle()
          .scaledToFit()
          .frame(width: 10)
          .foregroundColor(self.curSlideIndex >= i ? Color(.systemIndigo) : Color(.systemGray))
      }
    }
  }
}

struct OnboardingView_Previews: PreviewProvider {
  static var previews: some View {
    OnboardingView(data: Onboarding.data, doneFunction: {})
  }
}
