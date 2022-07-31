//
//  ContentView.swift
//  Semhas-WatchOS WatchKit Extension
//
//  Created by Muhammad Rifki Widadi on 27/07/22.
//

import SwiftUI
import Combine



struct DeepBreathingPreparationView: View {

    var body: some View {
      VStack {
        Spacer()
        Text("Pokokonya disini penjelasans ebelum mulai sesi deep breathing")
          .font(.subheadline)
          .multilineTextAlignment(.center)
        Spacer()

        NavigationLink(destination: DeepBreathView()) {
          Text("Selanjutnya")
        }

      }
    }
}

struct DeepBreathingPreparationView_Previews: PreviewProvider {
    static var previews: some View {
        DeepBreathingPreparationView()
    }
}
