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
  
  @StateObject var cvm = CounsellorViewModel()
  @ObservedObject var membershipViewModel: MembershipViewModel
  @ObservedObject var scheduleViewModel: ScheduleViewModel
  @ObservedObject var vm = JournalsViewModel()
  @ObservedObject var kesslerViewModel: KesslerViewModel
  @Environment(\.presentationMode) var presentationMode
  let navigator: ScheduleNavigator
  
  @State private var isShowAddLinkMeeting = false
  
  @State private var isShowAlert = false
  @State private var storeError: Error?
  @State var isRejected = false
  @State var isDone = false
  
  @State private var isShowConfirmation = false
  @State private var isShowJournalsView = false
  
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
                if schedule.status == .scheduled {
                  Text("Link")
                    .font(.system(size: 15, weight: .bold))
                }
                
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
                if schedule.status == .scheduled {
                  Text(schedule.linkMeeting.isEmpty ? "Belum ada link" : schedule.linkMeeting)
                    .font(.system(size: 15, weight: .medium))
                }
                
              }
            }.padding()
            
            if schedule.status == .scheduled {
              Button {
                isShowAddLinkMeeting.toggle()
              } label: {
                HStack {
                  Spacer()
                  Label(schedule.linkMeeting.isEmpty ? "Tambah Link" : "Update Link", systemImage: "link.badge.plus")
                    .foregroundColor(.white)
                  Spacer()
                }
                .padding()
                .background(
                  RoundedRectangle(cornerRadius: 12)
                    .fill(Color.accentPurple)
                )
              }
            }
            
            Text("Catatan Keluhan")
              .font(.system(size: 18, weight: .bold))
          }
          
          Text(schedule.note.isEmpty ? "Tidak ada keluhan" : schedule.note)
            .padding()
            .frame(width: UIScreen.main.bounds.width / 1.1)
            .background(Color(uiColor: .softYellow))
            .cornerRadius(12)
          if schedule.status == .scheduled {
            ZStack {
              NavigationLink(destination: CounsellorJurnalView(viewModel: vm, userName: user?.name ?? ""), isActive: $isShowJournalsView) {
                EmptyView()
              }
              Button {
                isShowJournalsView.toggle()
              } label: {
                HStack {
                  Label("Jurnal \(user?.name ?? "")", systemImage: "pencil.and.outline")
                    .foregroundColor(.white)
                  Spacer()
                  Image(systemName: "chevron.right")
                    .foregroundColor(.white)
                }
                .padding()
                .background(
                  RoundedRectangle(cornerRadius: 12)
                    .fill(Color.accentPurple)
                )
              }
            }
            .padding(.vertical, 10)
            
            Text("Hasil pengukuran kessler terakhir")
              .font(.system(size: 18, weight: .bold))
            
            KesslerResultItemView(kesslerResult: kesslerViewModel.fetchLastKesslerState.value ?? KesslerResult.init())
          }
          
        }.padding()
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
      if schedule.status == .scheduled && !schedule.linkMeeting.isEmpty {
        Button {
          isShowConfirmation.toggle()
        } label: {
          HStack {
            Spacer()
            Label("Akhiri Sesi Konseling", systemImage: "xmark.circle.fill")
              .foregroundColor(.red)
            Spacer()
          }
          .padding()
          .background(
            RoundedRectangle(cornerRadius: 12)
              .stroke(.red, lineWidth: 2)
          )
          .padding()
        }
      }
    }
    .sheet(isPresented: $isShowAddLinkMeeting) {
      CounsellorAddLinkMeeting(action: {
        cvm.updateScheduleCounsellor(schedule.id.uuidString)
      }, link: $cvm.link, isAdd: schedule.linkMeeting.isEmpty)
    }
    .navigationTitle("Detail Konseling")
    .navigationBarTitleDisplayMode(.inline)
    .confirmationDialog("Apakah kamu yakin?", isPresented: self.$isShowConfirmation) {
      Button(role: .destructive) {
        cvm.updateStatusScheduelingToDone(schedule.id.uuidString)
        isDone.toggle()
      } label: {
        Text("Akhiri")
      }
      
      Button(role: .cancel, action: {}) {
        Text("Kembali")
      }
    }
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
      cvm.link = self.schedule.linkMeeting
      kesslerViewModel.fetchLastKesslerById(id: schedule.userId)
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
  
  private var sortedJournal: [Journal] {
    return vm.journals.sorted {
      $1.date < $0.date
    }
  }
}

struct CounsellorConfirmScheduleView_Previews: PreviewProvider {
  static var previews: some View {
    CounsellorConfirmScheduleView(isConfirm: true, schedule: Schedule.init(), membershipViewModel: AppAssembler.shared.resolve(), scheduleViewModel: AppAssembler.shared.resolve(), kesslerViewModel: AppAssembler.shared.resolve(), navigator: AppAssembler.shared.resolve())
  }
}
