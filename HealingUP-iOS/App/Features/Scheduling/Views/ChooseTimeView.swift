//
//  ChooseTimeView.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 19/07/22.
//

import SwiftUI

struct ChooseTimeView: View {
  @State private var date = Date()
  @State var note = ""
  @State private var isShowAlert = false
  @State private var storeError: Error?
  @EnvironmentObject var navigationHelper: NavigationHelper
  @ObservedObject var viewModel: ScheduleViewModel
  @ObservedObject var membershipViewModel: MembershipViewModel
  @State private var isDone = false

  let counsellor: User
  let navigator: ScheduleNavigator

  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(alignment: .leading) {
        DatePicker("Picker Date", selection: $date)
          .datePickerStyle(.graphical)
        Text("Catatan Keluhan")
          .font(.system(size: 18, weight: .bold))

        VStack {
          TextView(text: $note)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: UIScreen.main.bounds.height/6, maxHeight: .infinity)
        }
        .padding()
        .background(Color(uiColor: .softYellow))
        .cornerRadius(10)
      }
      .padding(.bottom)

      .fullScreenCover(isPresented: $isDone, onDismiss: {
        self.navigationHelper.selectionSchedule = nil
      }) {
        navigator.navigateToResult(
          title: "Jadwal berhasil dibuat",
          icon: .icSuccess,
          message: "Permintaan anda berhasil dibuat, silahkan menunggu konfirmasi dari psikolog untuk memulai konsultasi.",
          buttonTitle: "OK")
      }

      ButtonDefaultView(title: "Request", action: {
        let param: Schedule = .init(
          userId: SessionManager.getUserId(),
          counsellorId: counsellor.email,
          schedule: date,
          note: note,
          status: .waiting)
        viewModel.createSchedule(schedule: param)
      })
      .padding(.bottom)
    }
    .padding(.horizontal)
    .navigationTitle("Pilih Tanggal & Waktu")
    .navigationBarTitleDisplayMode(.inline)
    .alert(isPresented: $isShowAlert) {
      Alert(
        title: Text("Gagal"),
        message: Text("\(storeError?.localizedDescription ?? "Unknown Error")"),
        dismissButton: .default(Text("OK"))
      )
    }
    .onViewStatable(
      viewModel.$createScheduleState,
      onSuccess: { _ in
        isShowAlert = false
        membershipViewModel.fetchUser(email: counsellor.email)
      },
      onError: { error in
        storeError = error
        isShowAlert = true
      })
    .onViewStatable(
      membershipViewModel.$userByEmailState,
      onSuccess: { data in
        isDone = true
        isShowAlert = false
        NotificationService.shared.send(to: [data.fcmToken], notification: .schedulePlaced)
      },
      onError: { error in
        storeError = error
        isShowAlert = true
      }
    )
    .progressHUD(isShowing: $viewModel.createScheduleState.isLoading)
    .progressHUD(isShowing: $membershipViewModel.userByEmailState.isLoading)
  }
}

struct ChooseTimeView_Previews: PreviewProvider {
  static var previews: some View {
    ChooseTimeView(viewModel: AppAssembler.shared.resolve(), membershipViewModel: AppAssembler.shared.resolve(), counsellor: User(), navigator: AppAssembler.shared.resolve())
  }
}
