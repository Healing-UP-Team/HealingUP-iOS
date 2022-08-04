//
//  ScheduleTabItem.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 19/07/22.
//

import SwiftUI

struct CounselingSchedule {
  var schedule: Schedule
  var counselor: User
}

struct ScheduleTabItem: View {
  @EnvironmentObject var navigationHelper: NavigationHelper
  let navigator: ScheduleNavigator
  @ObservedObject var viewModel: ScheduleViewModel

  @State var storeError: Error?
  @State var isShowAlert = false
  @State var schedules = [Schedule]()
  @State var selectedIndex: Int = 0
  @State var isShowCounsellor = false

  let titles: [String] = ["Menunggu", "Ditolak", "Selesai"]

  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack {
        Image(uiImage: .imgCounseling)
          .resizable()
          .scaledToFit()
          .frame(height: UIScreen.main.bounds.height/3)

        ButtonDefaultView(title: "Ajukan jadwal", action: {
          self.navigationHelper.selectionSchedule = "counsellor"
        }).padding()

        VStack(alignment: .leading) {
          HStack {
            Text("KONSELING TERJADWAL")
              .font(.system(size: 15, weight: .bold))
            Spacer()
          }
          if !schedules.isEmpty {
            ForEach(filteringSchedule(status: .scheduled, schedules), id: \.id) { item in
              NavigationLink(destination: navigator.navigateToScheduleDetail(schedule: item)) {
                let viewModel = MembershipViewModel(firebaseManager: AppAssembler.shared.resolve(), schedule: item)
                ScheduleCardComponentView(viewModel: viewModel)
              }
            }
          }
        }
        .padding()

        VStack(alignment: .leading) {
          HStack {
            Text("KONSELING")
              .font(.system(size: 15, weight: .bold))
            Spacer()
          }

          SegmentedControlView(selectedIndex: $selectedIndex, titles: titles)
            .padding(.bottom, 5)

          switch selectedIndex {
          case 0:
            if !schedules.isEmpty {
              ForEach(filteringSchedule(status: .waiting, schedules), id: \.id) { item in
                let viewModel = MembershipViewModel(firebaseManager: AppAssembler.shared.resolve(), schedule: item)
                ScheduleCardComponentView(viewModel: viewModel)
              }
            }
          case 1:
            if !schedules.isEmpty {
              ForEach(filteringSchedule(status: .rejected, schedules), id: \.id) { item in
                let viewModel = MembershipViewModel(firebaseManager: AppAssembler.shared.resolve(), schedule: item)
                ScheduleCardComponentView(viewModel: viewModel)
              }
            }

          default:
            if !schedules.isEmpty {
              ForEach(filteringSchedule(status: .done, schedules), id: \.id) { item in
                let viewModel = MembershipViewModel(firebaseManager: AppAssembler.shared.resolve(), schedule: item)
                ScheduleCardComponentView(viewModel: viewModel)
              }
            }
          }
        }
        .padding()
        NavigationLink(destination: navigator.naviageteToCounsellorChoice(), tag: "counsellor", selection: $navigationHelper.selectionSchedule) {
          EmptyView()
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
    .onAppear {
      viewModel.fetchSchedule()
    }
    .onViewStatable(
      viewModel.$fetchScheduleState,
      onSuccess: { data in
        schedules = data
        isShowAlert = false
      },
      onError: { error in
        storeError = error
        isShowAlert = true
      })
    .progressHUD(isShowing: $viewModel.fetchScheduleState.isLoading)
  }

  private func filteringSchedule(status: ScheduleStatus, _ schedule: [Schedule]) -> [Schedule] {
    let filteredSchedule = schedule.filter { $0.status == status }
    return filteredSchedule
  }
}

struct ScheduleTabItem_Previews: PreviewProvider {
  static var previews: some View {
    ScheduleTabItem(navigator: AppAssembler.shared.resolve(), viewModel: AppAssembler.shared.resolve())
  }
}
