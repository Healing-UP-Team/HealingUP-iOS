//
//  DeepBreathView.swift
//  Semhas-WatchOS WatchKit Extension
//
//  Created by Muhammad Rifki Widadi on 31/07/22.
//

import SwiftUI

struct DeepBreathView: View {
  @StateObject var wm = WorkoutManager()
  @StateObject var vm = DeepBreathViewModel()
  @ObservedObject var heart = HeartRateViewModel()
  @State var progressValue: Float = 0.0

  var body: some View {
    ZStack {
      NavigationLink(destination: DeepBreathReport(), isActive: $vm.isSessionCompleted, label: { EmptyView() })
      NavigationLink(destination: ContentView(), isActive: $vm.isSessionStopped, label: { EmptyView() })
      TabView {
        VStack {
          Spacer()
          ZStack {
            ZStack {
              Circle()
                .frame(width: 60, height: 60)
                .foregroundColor(vm.animationColor.opacity(0.4))
                .scaleEffect(vm.isStartBreathAnimation ? 1.1 : 1)
                .opacity(vm.isStartBreathAnimation ? 1 : 0)
              Circle()
                .frame(width: 66, height: 66)
                .foregroundColor(vm.animationColor.opacity(0.3))
                .scaleEffect(vm.isStartBreathAnimation ? 1.3 : 1)
                .opacity(vm.isStartBreathAnimation ? 1 : 0)
              Circle()
                .frame(width: 70, height: 70)
                .foregroundColor(vm.animationColor.opacity(0.1))
                .scaleEffect(vm.isStartBreathAnimation ? 1.5 : 1)
                .opacity(vm.isStartBreathAnimation ? 1 : 0)
            }
            .animation(vm.isStartBreathAnimation ?
              .linear(duration: 4)
              .repeatForever(autoreverses: true)
                       : nil,
                       value: vm.isStartBreathAnimation)

            Text(vm.instruction)
          }
          Spacer()
          Text(vm.counterText)

        }
        .onAppear {
          vm.isStartBreathAnimation = true
          vm.setupTimer()

          wm.requestAuthorization()
        }

        Button("Berhenti") {
          wm.endWorkout()
          vm.isSessionStopped = true
          vm.stopTimer()
          vm.hapticTimer?.cancel()
          vm.isStartBreathAnimation = false
        }
      }
      .navigationBarHidden(true)
      .tabViewStyle(.page(indexDisplayMode: .always))
    .indexViewStyle(.page(backgroundDisplayMode: .automatic))
    }


  }
}

struct DeepBreathView_Previews: PreviewProvider {
  static var previews: some View {
    DeepBreathView()
  }
}
