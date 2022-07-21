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
      VStack {
        Text("No Data")
          .font(.system(size: 18, weight: .semibold))
      }
    } else {
      ScrollView(showsIndicators: false) {
        if !kResults.isEmpty {
          ForEach(kResults, id: \.id) { result in
            VStack {
              KesslerResultItemView(kesslerResult: result)
            }
          }
        }
      }
      .navigationTitle("Stress Level")
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
