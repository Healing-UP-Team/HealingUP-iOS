//
//  DeepBreathViewModel.swift
//  Semhas-WatchOS WatchKit Extension
//
//  Created by Muhammad Rifki Widadi on 31/07/22.
//

import Combine
import SwiftUI

class DeepBreathViewModel: ObservableObject {
  @Published var isStartBreathAnimation = false
  @Published var counter: Int = 300
  @Published var counterText: String = ""
  @Published var instruction: String = ""
  @Published var animationColor: Color = .yellow
  @Published var isSessionCompleted: Bool = false
  @Published var isSessionStopped: Bool = false
  
  private var cancellables = Set<AnyCancellable>()
  var hapticTimer: AnyCancellable?


  private var inhale = 4
  private var exhale = 4
  private var normal = 7


  deinit {
    self.stopTimer()
    self.hapticTimer?.cancel()
    self.isStartBreathAnimation = false
  }

  func setupTimer() {
    Timer
      .publish(every: 1, on: .main, in: .common)
      .autoconnect()
      .sink { [weak self] _ in
        guard let self = self else { return }

        if self.counter > 0 {
          self.counter -= 1
        } else {
          self.stopTimer()
          self.isSessionCompleted = true
        }

        if self.inhale > 0 {

          if self.inhale == 4 {
            self.animationColor = .yellow
            //memastikan hanya disetup sekali, pas diawal
            self.setupHapticsCaller()
          }
          self.inhale -= 1
          self.instruction = "Tarik napas, tangan mengikuti gerakan perut"
        } else if self.exhale > 0 {
          self.exhale -= 1
          self.instruction = "Hembuskan dari mulut, seperti melewati sedotan"
          if self.exhale == 0 {
            //memastikan hanya disetup sekali, pas diakhir
            self.hapticTimer?.cancel()
            self.animationColor = .green
          }
        } else if self.normal > 0 {
          self.normal -= 1
          self.instruction = "Istirahat \(self.normal), bernapas seperti biasa"

        }else {
          self.inhale = 4
          self.exhale = 4
          self.normal = 7
        }
        let minutes = self.counter / 60
        let seconds = self.counter % 60


        self.counterText = String(format: "%02d:%02d", minutes, seconds)
      }
      .store(in: &cancellables)
  }

  func setupHapticsCaller() {
    var count = 0
    self.hapticTimer = Timer
      .publish(every: 0.2, on: .main, in: .common)
      .autoconnect()
      .sink { [weak self] _ in
        guard self != nil else { return }

        if count < 10 {
          if count == 0 {
            self?.isStartBreathAnimation = true
          }
          WKInterfaceDevice.current().play(.start)
          print("\(count): medium")
        } else if count < 30{
          if count % 10 == 0 {
            WKInterfaceDevice.current().play(.stop)
            print("\(count): rigid")
          }
        } else if count == 50{
            count = 0
        }
        count += 1
      }

  }

  func stopTimer() {
    for item in cancellables {
      item.cancel()
      self.counter = 300
      self.isStartBreathAnimation = false
    }
  }
}
