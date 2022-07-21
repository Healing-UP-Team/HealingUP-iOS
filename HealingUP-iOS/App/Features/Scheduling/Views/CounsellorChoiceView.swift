//
//  CounsellorChoice.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 19/07/22.
//

import SwiftUI

struct CounsellorChoiceView: View {
  @ObservedObject var membershipViewModel: MembershipViewModel
  @State var isShowAlert = false
  @State var alertError: Error?
  @State var tabBarFrame: CGRect?

  let navigator: ScheduleNavigator

  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack {
        ForEach(membershipViewModel.allUserState.value ?? [User](), id: \.userId) { item in
          NavigationLink(destination: navigator.navigateToChooseTime(counsellor: item)) {
            counsellorCard(user: item)
          }
        }
      }
    }
    .onAppear {
      membershipViewModel.fetchUsers(isUser: false)
    }
    .alert(isPresented: $isShowAlert) {
      Alert(
        title: Text("Gagal"),
        message: Text("\(alertError?.localizedDescription ?? "Unknown error")"),
        dismissButton: .default(Text("OK"))
      )
    }
    .onViewStatable(
      membershipViewModel.$allUserState,
      onSuccess: { _ in
        isShowAlert = false
      },
      onError: { error in
        alertError = error
        isShowAlert = true
      })
     .progressHUD(isShowing: $membershipViewModel.allUserState.isLoading)
    .navigationTitle("Choose your counsellor")
    .navigationBarTitleDisplayMode(.inline)
  }

  @ViewBuilder
  private func counsellorCard(user: User) -> some View {
    VStack {
      HStack(alignment: .center, spacing: 15) {
        Image(systemName: "person")
          .resizable()
          .scaledToFit()
          .frame(height: 100)
          .padding(5)
          .overlay(
            RoundedRectangle(cornerRadius: 5)
              .stroke(.gray, lineWidth: 1)
          )
        VStack(alignment: .leading, spacing: 5) {
          Text(user.name)
          HStack {
            Image(systemName: "bag.fill")
            Text("6 Tahun")
          }
          .font(.system(size: 10))
          .padding(.vertical, 5)
          .padding(.horizontal, 10)
          .background(Color(uiColor: .softYellow))
          .cornerRadius(10)

          Text("Available 09.00 - 17.00")
            .font(.system(size: 13))
          Spacer()
        }
        Spacer()
        Image(systemName: "chevron.forward")
      }
      Divider()
        .padding(.vertical)
    }
    .padding()
  }
}

struct CounsellorChoice_Previews: PreviewProvider {
  static var previews: some View {
    CounsellorChoiceView(membershipViewModel: AppAssembler.shared.resolve(), navigator: AppAssembler.shared.resolve())
  }
}
