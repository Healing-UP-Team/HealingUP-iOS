//
//  KesslerHistoryView.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 06/06/22.
//

import SwiftUI

struct KesslerHistoryView: View {
  @ObservedObject var kesslerViewModel: KesslerViewModel
  @State private var isShowAlert = false
  @State private var fetchError: Error?
  @State var kResults = [KesslerResult]()
  @State var isFirstTime = false
  
  var body: some View {
    if isFirstTime {
      EmptyStateView(image: .kesslerIntro, title: "Tidak ada riwayat", message: "Sepertinya kamu belum mengukur tingkat stres sebelumnya")
    } else {
      ScrollView(showsIndicators: false) {
        Text("Hi! Kamu bisa melihat daftar pengukuran stres yang telah dilakukan sebelumnya")
          .font(.system(size: 13, weight: .semibold))
          .foregroundColor(Color.gray)
          .padding()
        if !kResults.isEmpty {
          ForEach(kResults, id: \.id) { result in
            VStack {
              KesslerResultItemView(kesslerResult: result)
            }
          }
        }
      }
      .padding(.horizontal)
      .navigationTitle("Riwayat Pengukuran")
      .alert(isPresented: $isShowAlert) {
        Alert(
          title: Text("Gagal"),
          message: Text("\(fetchError?.localizedDescription ?? "Field tidak boleh kosong")"),
          dismissButton: .default(Text("OK"))
        )
      }
      .onAppear {
        kesslerViewModel.fetchKesslerResult()
      }
      .onViewStatable(
        kesslerViewModel.$fetchKesslerResultState,
        onSuccess: { data in
          self.kResults = data
          self.isFirstTime = false
        },
        onEmpty: {
          self.isFirstTime = true
        },
        onError: { error in
          fetchError = error
          isShowAlert = true
        })
      .progressHUD(isShowing: $kesslerViewModel.fetchKesslerResultState.isLoading)
    }
  }
}

struct KesslerHistoryView_Previews: PreviewProvider {
  static var previews: some View {
    KesslerHistoryView(kesslerViewModel: AppAssembler.shared.resolve())
  }
}
