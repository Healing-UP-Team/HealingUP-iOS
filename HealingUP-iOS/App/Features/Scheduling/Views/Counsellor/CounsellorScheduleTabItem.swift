//
//  CounsellorScheduleTabItem.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 20/07/22.
//

import SwiftUI

struct CounsellorScheduleTabItem: View {

  let navigator: ScheduleNavigator
  @ObservedObject var viewModel: ScheduleViewModel
  @State var schedules = [Schedule]()
  @State var storeError: Error?
  @State var isShowAlert = false

  let titles: [String] = ["Menunggu", "Ditolak", "Selesai"]
  @State var selectedIndex: Int = 0

  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(alignment: .leading) {
        HStack {
          Text("Konseling Terjadwal")
            .font(.system(size: 15, weight: .bold))
          Spacer()
        }
        if !schedules.isEmpty {
          ForEach(filteringSchedule(status: .scheduled, schedules), id: \.id) { item in
            NavigationLink(destination: navigator.navigateToScheduleConfirm(isConfirm: true, schedule: item)) {
              scheduleCard(schedule: item)
            }
          }
        }
      }
      .padding()
      VStack(alignment: .leading) {
        HStack {
          Text("Butuh Konfirmasi")
            .font(.system(size: 15, weight: .bold))
          Spacer()
        }

        SegmentedControlView(selectedIndex: $selectedIndex, titles: titles)
          .padding(.bottom, 5)

        switch selectedIndex {
        case 0:
          if !schedules.isEmpty {
            ForEach(filteringSchedule(status: .waiting, schedules), id: \.id) { item in
              NavigationLink(destination: navigator.navigateToScheduleConfirm(isConfirm: true, schedule: item)) {
                scheduleCard(schedule: item)
              }
            }
          }
        case 1:
          if !schedules.isEmpty {
            ForEach(filteringSchedule(status: .rejected, schedules), id: \.id) { item in
              NavigationLink(destination: navigator.navigateToScheduleConfirm(isConfirm: true, schedule: item)) {
                scheduleCard(schedule: item)
              }
            }
          }

        default:
          if !schedules.isEmpty {
            ForEach(filteringSchedule(status: .done, schedules), id: \.id) { item in
              NavigationLink(destination: navigator.navigateToScheduleConfirm(isConfirm: true, schedule: item)) {
                scheduleCard(schedule: item)
              }
            }
          }
        }
      }
      .padding()
    }
    .alert(isPresented: $isShowAlert) {
      Alert(
        title: Text("Gagal"),
        message: Text("\(storeError?.localizedDescription ?? "Unknown Error")"),
        dismissButton: .default(Text("OK"))
      )
    }
    .refreshable {
      viewModel.fetchCounsellorSchedule()
    }
    .onAppear {
      viewModel.fetchCounsellorSchedule()
    }
    .onViewStatable(
      viewModel.$fetchCounsellorScheduleState,
      onSuccess: { data in
        schedules = data
        isShowAlert = false
      },
      onError: { error in
        storeError = error
        isShowAlert = true
      })
    .progressHUD(isShowing: $viewModel.fetchCounsellorScheduleState.isLoading)
  }

  private func filteringSchedule(status: ScheduleStatus, _ schedule: [Schedule]) -> [Schedule] {
    let filteredSchedule = schedule.filter { $0.status == status }
    return filteredSchedule
  }

  @ViewBuilder
  private func scheduleCard(schedule: Schedule) -> some View {
    HStack(alignment: .top) {
      VStack(alignment: .leading) {
        Text("Konseling")
          .font(.system(size: 17, weight: .semibold))
          .foregroundColor(Color(uiColor: .accentPurple))
          .padding(.bottom, 5)
        Text(schedule.schedule.toStringWith(format: "EE, dd MMM yyyy") ?? "")
          .font(.system(size: 15, weight: .medium))
          .foregroundColor(Color(uiColor: .accentPurple))
      }
      Spacer()
      Text(schedule.status.rawValue)
        .font(.system(size: 13, weight: .semibold))
        .foregroundColor(Color(uiColor: .accentPurple))
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .background(Color(uiColor: .softYellow))
        .cornerRadius(12)
    }
    .padding()
    .background(Color(uiColor: .softBlue))
    .cornerRadius(20)
  }
}

struct CounsellorScheduleTabItem_Previews: PreviewProvider {
  static var previews: some View {
    CounsellorScheduleTabItem(navigator: AppAssembler.shared.resolve(), viewModel: AppAssembler.shared.resolve())
  }
}
