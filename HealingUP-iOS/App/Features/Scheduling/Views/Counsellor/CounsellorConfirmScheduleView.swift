//
//  CounsellorConfirmScheduleView.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 21/07/22.
//

import SwiftUI

struct CounsellorConfirmScheduleView: View {
  let isConfirm: Bool
  let schedule: Schedule
  @State var user: User?
  @ObservedObject var membershipViewModel: MembershipViewModel
  @ObservedObject var scheduleViewModel: ScheduleViewModel
  @ObservedObject var vm = JournalsViewModel()

  @Environment(\.presentationMode) var presentationMode
  let navigator: ScheduleNavigator

  @State private var isShowAddLinkMeeting = false

  @State private var isShowAlert = false
  @State private var storeError: Error?
  @State var isRejected = false
  @State var isDone = false

  var body: some View {
    VStack {
      ScrollView(showsIndicators: false) {
        VStack(alignment: .center) {
          VStack(alignment: .leading) {
            Text("Pasien")
              .font(.system(size: 18, weight: .bold))
            HStack {
              VStack(alignment: .leading, spacing: 5) {
                Text("Nama")
                  .font(.system(size: 15, weight: .bold))
                Text("Umur")
                  .font(.system(size: 15, weight: .bold))
                Text("Jam")
                  .font(.system(size: 15, weight: .bold))
                Text("Tanggal")
                  .font(.system(size: 15, weight: .bold))
              }
              Spacer()
              VStack(alignment: .trailing, spacing: 5) {
                Text(user?.name ?? "")
                  .font(.system(size: 15, weight: .medium))
                Text(String(user?.age ?? 0))
                  .font(.system(size: 15, weight: .medium))
                Text(schedule.schedule.toStringWith(format: "HH:mm") ?? "")
                Text(schedule.schedule.toStringWith(format: "EE, dd MMM yyyy") ?? "")
                  .font(.system(size: 15, weight: .medium))
              }
            }.padding()


            if schedule.status == .scheduled && schedule.linkMeeting.isEmpty {
              Button {
                isShowAddLinkMeeting.toggle()
              } label: {
                HStack {
                  Spacer()
                  Label("Tambah Link", systemImage: "link.badge.plus")
                    .foregroundColor(.white)
                  Spacer()
                }
                .padding()
                .background(Color.accentPurple)


              }
            }



            Text("Catatan Keluhan")
              .font(.system(size: 18, weight: .bold))
          }

          Text(schedule.note)
            .padding()
            .frame(width: UIScreen.main.bounds.width / 1.1)
            .background(Color(uiColor: .softYellow))
            .cornerRadius(12)
        }.padding()

        if schedule.status == .scheduled {
          VStack(alignment: .leading) {
            Text("Jurnal \(user?.name ?? "")")
              .font(.system(size: 18, weight: .bold))
          }
          ForEach(sortedJournal) { journal in
              JournalCell(journal: journal)
          }
        }

      }

      if isConfirm && schedule.status == .waiting {
        ButtonDefaultView(title: "Terima", action: {
          var newSchedule = schedule
          newSchedule.status = .scheduled
          isRejected = false
          scheduleViewModel.updateSchedule(schedule: newSchedule)
        })

        ButtonDefaultView(title: "Tolak", action: {
          var newSchedule = schedule
          newSchedule.status = .rejected
          isRejected = true
          scheduleViewModel.updateSchedule(schedule: newSchedule)
        }, backgroundColor: .white, titleColor: .accentColor)

      }
    }
    .sheet(isPresented: $isShowAddLinkMeeting) {
      CounsellorAddLinkMeeting()
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
      membershipViewModel.fetchUserById(id: schedule.userId)
      vm.fetchJournalById(userId: schedule.userId)
    }
    .fullScreenCover(isPresented: $isDone, onDismiss: {
      presentationMode.wrappedValue.dismiss()
    }) {
      navigator.navigateToResult(
        title: "Status jadwal berhasil diperbarui",
        icon: .icSuccess,
        message: "Terima kasih telah konfirmasi. Pasien akan mendapatkan notifikasi",
        buttonTitle: "OK")
    }
    .onViewStatable(
      membershipViewModel.$userByIdState,
      onSuccess: { data in
        user = data
        isShowAlert = false
      },
      onError: { error in
        storeError = error
        isShowAlert = true
      }
    )
    .onViewStatable(
      scheduleViewModel.$updateScheduleState,
      onSuccess: { _ in
        isShowAlert = false
        isDone = true
        if let user = user {
          if isRejected {
            NotificationService.shared.send(to: [user.fcmToken], notification: .scheduleCanceled("Konselor tidak bisa di waktu yang kamu ajukan"))
          } else {
            NotificationService.shared.send(to: [user.fcmToken], notification: .updateScheduleStatus(.scheduled))
          }
        }
      },
      onError: { error in
        storeError = error
        isShowAlert = true
      }
    )
    .progressHUD(isShowing: $membershipViewModel.userByIdState.isLoading)
  }

  private var sortedJournal : [Journal] {
    return vm.journals.sorted {
      $1.date < $0.date
    }
  }
}

struct CounsellorConfirmScheduleView_Previews: PreviewProvider {
  static var previews: some View {
    CounsellorConfirmScheduleView(isConfirm: true, schedule: Schedule.init(), membershipViewModel: AppAssembler.shared.resolve(), scheduleViewModel: AppAssembler.shared.resolve(), navigator: AppAssembler.shared.resolve())
  }
}
