//
//  DeepBreathReport.swift
//  Semhas-WatchOS WatchKit Extension
//
//  Created by Muhammad Rifki Widadi on 31/07/22.
//

import SwiftUI

struct DeepBreathReport: View {
  @ObservedObject var heart = HeartRateViewModel()
    var body: some View {
      List {
        HStack {
          Image(systemName: "doc.zipper")
            .font(.system(size: 50))
          Text("laporan Sesi Deep Breath")
        }
        Section("Time") {
          Text("5 Menit")
        }
        Section("Detak Jantung") {
          HStack(spacing: 10) {
            Image(systemName: "heart.fill")
              .foregroundColor(.red)
            HStack(alignment: .center, spacing: 0) {
              Text("\(heart.currentHeartRateBPM)")
                .font(.system(size: 20))
              Text("BPM")
                .font(.system(size: 14))
            }

          }
        }
        Section("Level Stress") {
          Text("Well")
        }
        NavigationLink {
          DeepBreathingPreparationView()
        } label: {
          HStack {
            Spacer()
            Text("DONE")
              .foregroundColor(.green)
              .font(.headline)
            Spacer()
          }

        }



      }
      .listStyle(.elliptical)
      .navigationBarHidden(true)
    }
}

struct DeepBreathReport_Previews: PreviewProvider {
    static var previews: some View {
        DeepBreathReport()
    }
}
