//
//  ContentView.swift
//  Semhas-WatchOS WatchKit Extension
//
//  Created by Muhammad Rifki Widadi on 27/07/22.
//

import SwiftUI
import Combine

enum Instructions {
  case one, two, three, startSession
}

struct DeepBreathingPreparationView: View {
  @State private var selection: Instructions = .one
  @State private var isStartSession = false

  var body: some View {
    ZStack {
      NavigationLink(destination: DeepBreathView(), isActive: $isStartSession) {
        EmptyView()
      }.hidden()
      VStack {
          Spacer()
          TabView(selection: $selection) {
            Text("Cari tempat yang kondusif")
              .tag(Instructions.one)
            Text("Tidur telentang")
              .tag(Instructions.two)
            Text("Letakkan tangan di perut bagian bawah")
              .tag(Instructions.three)
            Button("Mulai"){
              isStartSession.toggle()
            }
              .tag(Instructions.startSession)
          }
          .font(.subheadline)
          .multilineTextAlignment(.center)
          .scenePadding()
          Spacer()

      }
    }
  }
}

struct DeepBreathingPreparationView_Previews: PreviewProvider {
  static var previews: some View {
    DeepBreathingPreparationView()
  }
}
