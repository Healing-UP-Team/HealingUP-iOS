//
//  SchedulingDetailView.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 04/08/22.
//

import SwiftUI

struct SchedulingDetailView: View {
  let schedule: Schedule
  @ObservedObject var membershipViewModel: MembershipViewModel
  @ObservedObject var scheduleViewModel: ScheduleViewModel

  @State private var isShowAlert = false
  @State private var storeError: Error?

  var body: some View {
    VStack {
      ScrollView(showsIndicators: false) {
        VStack(alignment: .center) {
          VStack(alignment: .leading) {
            Text("Detail")
              .font(.system(size: 18, weight: .bold))
            HStack {
              VStack(alignment: .leading, spacing: 5) {
                Text("Konselor")
                  .font(.system(size: 15, weight: .bold))
                Text("Tanggal")
                  .font(.system(size: 15, weight: .bold))
                Text("Waktu")
                  .font(.system(size: 15, weight: .bold))
              }
              Spacer()
              VStack(alignment: .trailing, spacing: 5) {
                Text(membershipViewModel.userByEmailState.value?.name ?? "")
                  .font(.system(size: 15, weight: .medium))
                Text(schedule.schedule.toStringWith(format: "EE, dd MMM yyyy") ?? "")
                  .font(.system(size: 15, weight: .medium))
                Text(schedule.schedule.toStringWith(format: "HH:mm") ?? "")
                  .font(.system(size: 15, weight: .medium))
              }
            }.padding()
            Text("Link Konseling")
              .font(.system(size: 18, weight: .bold))
              .padding(.vertical)
            Button {
              if let url = URL(string: schedule.linkMeeting) {
                UIApplication.shared.open(url)
              }
            }label: {
              Text(schedule.linkMeeting)
                .font(.system(size: 15, weight: .regular))
                .padding(.horizontal)
            }

            Text("Catatan Keluhan")
              .font(.system(size: 18, weight: .bold))
              .padding(.vertical)
          }

          Text(schedule.note)
            .padding()
            .frame(width: UIScreen.main.bounds.width / 1.1)
            .background(Color(uiColor: .softYellow))
            .cornerRadius(12)

        }.padding()
      }
    }
    .padding(.vertical)
    .navigationTitle("Detail Konseling")
    .navigationBarTitleDisplayMode(.inline)
    .alert(isPresented: $isShowAlert) {
      Alert(
        title: Text("Gagal"),
        message: Text("\(storeError?.localizedDescription ?? "Unknown Error")"),
        dismissButton: .default(Text("OK"))
      )
    }
    .onAppear {
      membershipViewModel.fetchUser(email: schedule.counsellorId)
    }
    .onViewStatable(
      membershipViewModel.$userByEmailState,
      onSuccess: { _ in
        isShowAlert = false
      },
      onError: { error in
        storeError = error
        isShowAlert = true
      }
    )
     .progressHUD(isShowing: $membershipViewModel.userByEmailState.isLoading)
  }
}

struct SchedulingDetailView_Previews: PreviewProvider {
  static var previews: some View {
    SchedulingDetailView(schedule: Schedule.init(), membershipViewModel: AppAssembler.shared.resolve(), scheduleViewModel: AppAssembler.shared.resolve())
  }
}
