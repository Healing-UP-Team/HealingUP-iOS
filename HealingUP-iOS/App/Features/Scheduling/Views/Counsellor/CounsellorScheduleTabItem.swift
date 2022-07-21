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

  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(alignment: .leading) {
        Text("Need confirmation")
          .font(.system(size: 18, weight: .semibold))
        if !schedules.isEmpty {
          ForEach(schedules, id: \.id) { item in
            NavigationLink(destination: navigator.navigateToScheduleConfirm(isConfirm: true, schedule: item)) {
              scheduleCard(schedule: item)
            }
          }
        }
      }.padding()
    }
    .alert(isPresented: $isShowAlert) {
      Alert(
        title: Text("Gagal"),
        message: Text("\(storeError?.localizedDescription ?? "Unknown Error")"),
        dismissButton: .default(Text("OK"))
      )
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

  @ViewBuilder
  private func scheduleCard(schedule: Schedule) -> some View {
    HStack(alignment: .top) {
      VStack(alignment: .leading) {
        Text("Conseling")
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
