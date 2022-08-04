//
//  DeepBreathReport.swift
//  HealingUp-Watch WatchKit Extension
//
//  Created by Muhammad Rifki Widadi on 03/08/22.
//

import SwiftUI

struct DeepBreathReport: View {
  @StateObject var wm = WorkoutManager()
  @ObservedObject var vm = DeepBreathViewModel()

  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {

        SummaryMetricView(
          title: "Pernapasan",
          value: "Perut",
          color: .green
        )

        SummaryMetricView(
          title: "Waktu Total",
          value: "5 Menit",
          color: .yellow
        )

        SummaryMetricView(
          title: "Total  Pernapasan Deep Breathing",
          value: "20 kali",
          color: .blue
        )

        NavigationLink("Selesai") {
          ContentView()
        }

      }

    }
    .scenePadding()
    .navigationTitle("Laporan")
    .navigationBarTitleDisplayMode(.inline)
    .navigationBarBackButtonHidden(true)
  }
}

struct DeepBreathReport_Previews: PreviewProvider {
  static var previews: some View {
    DeepBreathReport()
  }
}
