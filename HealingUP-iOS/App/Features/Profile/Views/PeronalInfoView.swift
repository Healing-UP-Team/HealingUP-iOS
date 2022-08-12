//
//  PeronalInfoView.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 12/08/22.
//

import SwiftUI

struct PeronalInfoView: View {
  @ObservedObject var viewModel: MembershipViewModel
  @State private var isShowAlert = false
  @State private var fetchError: Error?
  
    var body: some View {
      VStack {
        Image(uiImage: .imgTextLogo)
          .resizable()
          .scaledToFit()
          .frame(height: UIScreen.main.bounds.height/6)
          .padding()
        HStack {
          VStack(alignment: .leading, spacing: 20) {
            Text("Nama")
              .font(.system(size: 15, weight: .medium))
              .foregroundColor(Color.gray)
            Text("Email")
              .font(.system(size: 15, weight: .medium))
              .foregroundColor(Color.gray)
            Text("Umur")
              .font(.system(size: 15, weight: .medium))
              .foregroundColor(Color.gray)
          }
          Spacer()
          VStack(alignment: .trailing, spacing: 20) {
            Text(viewModel.userState.value?.name ?? "")
              .font(.system(size: 15, weight: .semibold))
            Text(viewModel.userState.value?.email ?? "")
              .font(.system(size: 15, weight: .semibold))
            Text("\(viewModel.userState.value?.age ?? 0)")
              .font(.system(size: 15, weight: .semibold))
          }
        }
        Spacer()
      }
      .padding()
      .navigationTitle("Informasi Personal")
      .navigationBarTitleDisplayMode(.inline)
      .alert(isPresented: $isShowAlert) {
        Alert(
          title: Text("Gagal"),
          message: Text("\(fetchError?.localizedDescription ?? "Field tidak boleh kosong")"),
          dismissButton: .default(Text("OK"))
        )
      }
      .onAppear {
        viewModel.fetchUser()
      }
      .onViewStatable(
        viewModel.$userState,
        onSuccess: { _ in
          isShowAlert = false
        },
        onError: { error in
          fetchError = error
          isShowAlert = true
        }
      )
     // .progressHUD(isShowing: $viewModel.userState.isLoading)
    }
}

struct PeronalInfoView_Previews: PreviewProvider {
    static var previews: some View {
      PeronalInfoView(viewModel: AppAssembler.shared.resolve())
    }
}
